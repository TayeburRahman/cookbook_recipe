String formatPlanName(String name) {
  return name
      .split('_')
      .map((word) => word.isNotEmpty
      ? word[0].toUpperCase() + word.substring(1)
      : '')
      .join(' ');
}
