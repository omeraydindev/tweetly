import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

FormFieldValidator<String> fullNameValidator() {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your full name";
    }
    return null;
  };
}

FormFieldValidator<String> usernameValidator() {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter a username";
    }

    final regex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!regex.hasMatch(value)) {
      return "Only alphanumeric characters and underscores are allowed";
    }
    
    return null;
  };
}

FormFieldValidator<String> bioValidator() {
  return (value) {
    if (value != null && value.length > 255) {
      return "Biography can't be longer than 255 chars";
    }
    return null;
  };
}

FormFieldValidator<String> emailValidator() {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter an email address";
    }
    if (!EmailValidator.validate(value)) {
      return "Please enter a valid email address";
    }
    return null;
  };
}

FormFieldValidator<String> passwordValidator() {
  return (value) {
    if (value == null || value.isEmpty) {
      return "Please enter a password";
    }
    if (value.length < 6) {
      return "Password can't be shorter than 6 chars";
    }
    return null;
  };
}
