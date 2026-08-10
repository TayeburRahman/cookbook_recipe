enum UserRole { user, owner, barber }

UserRole getRoleFromString(String role) {
  switch (role.toLowerCase()) {
    case 'owner':
      return UserRole.owner;
    case 'barber':
      return UserRole.barber;
    case 'user':
    default:
      return UserRole.user;
  }
}