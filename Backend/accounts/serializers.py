from django.contrib.auth.models import User
from rest_framework import serializers


class SignupSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(write_only=True)
    password = serializers.CharField(write_only=True, min_length=8)

    class Meta:
        model = User
        fields = ('id', 'email', 'password', 'full_name')

    def validate_email(self, value):
        value = value.lower().strip()
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError('A user with this email already exists.')
        return value

    def create(self, validated_data):
        full_name = validated_data.pop('full_name', '')
        # Use email as username
        user = User.objects.create_user(
            username=validated_data['email'],
            email=validated_data['email'],
            password=validated_data['password'],
        )
        # Profile is created by signal; just update full_name
        user.profile.full_name = full_name
        user.profile.save()
        return user


class ProfileSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(source='profile.full_name')
    email = serializers.EmailField(read_only=True)

    class Meta:
        model = User
        fields = ('id', 'email', 'full_name')

    def update(self, instance, validated_data):
        profile_data = validated_data.pop('profile', {})
        if 'full_name' in profile_data:
            instance.profile.full_name = profile_data['full_name']
            instance.profile.save()
        return instance
