import Parsing

extension Conversion where Self == AnyConversion<Substring.UTF8View, String> {
  static var toString: Self {
    Self(
      apply: {
          String(Substring($0))
      },
      unapply: {
          $0[...].utf8
      }
    )
  }
}

extension Conversion where Self == AnyConversion<Substring.UTF8View, String> {
   static var unicode: Self {
    Self(
      apply: {
        UInt32(Substring($0), radix: 16)
          .flatMap(UnicodeScalar.init)
          .map(String.init)
      },
      unapply: {
        $0.unicodeScalars.first
          .map { String(UInt32($0), radix: 16)[...].utf8 }
      }
    )
  }
}
