String formatPhoneNumber(String phone) {
  if (phone.length == 11) {
    return '${phone.substring(0, 3)}-${phone.substring(3, 7)}-${phone.substring(7)}';
  } else if (phone.length == 10) {
    return '${phone.substring(0, 3)}-${phone.substring(3, 6)}-${phone.substring(6)}';
  }
  return phone; // 형식이 맞지 않으면 그대로 반환
}
