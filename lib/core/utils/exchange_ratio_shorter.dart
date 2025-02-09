String shortRatio(double amount, int digits) =>
    amount < 0.01 ? amount.toStringAsPrecision(digits) : amount.toStringAsFixed(digits);
