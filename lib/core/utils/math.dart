/// GCD - Greatest Common Divisor
/// swap function is used. It needs less memory than recursive function
int gcd(int a, int b) {
  int tmp, n;

  if (a < b) {
    tmp = a;
    a = b;
    b = tmp;
  }

  while (b != 0) {
    n = a % b;
    a = b;
    b = n;
  }
  return a;
}

/// GCD - Gretest Common Divisor
/// it is recursive function, which means it might demands more memory
/// in such a case like Pibonacci
// int gcd(int a, int b) {
//   if (b == 0) return a;
//   return gcd(b, a % b);
// }

/// LCM - Least Common Multiple
int lcm(int a, int b) {
  return (a * b).abs() ~/ gcd(a, b);
}

void juggleLeft<T>(List<T> items, int k) {
  int d = -1, j;
  T tmp;

  for (int i = 0; i < gcd(items.length, k); i++) {
    j = i;
    tmp = items[i];

    while (true) {
      d = (j + k) % items.length;

      if (d == i) {
        break;
      }
      items[j] = items[d];
      j = d;
    }

    items[j] = tmp;
  }
}
