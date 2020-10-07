pub struct Playfair {
    key: [[char; 5]; 5],
}

/// This function will:
///
/// 1. Convert text to uppercase
/// 2. Scan text pairs for the same letter, insert an 'X' in between, taking into account the shift of previous insertions
/// 3. Append 'Z' to the end if needed
/// 4. Change 'J' to 'I' if there is any
fn prepare(plain: &str) -> Vec<char> {
    let mut chars: Vec<char> = plain.to_uppercase().replace("J", "I").chars().collect();
    let mut i = 0usize;
    while i < chars.len() - 1 {
        let (a, b) = (chars.get(i).unwrap(), chars.get(i + 1).unwrap());
        if a == b {
            chars.insert(i + 1, 'X');
        }
        i += 2;
    }
    if chars.len() % 2 != 0 {
        chars.push('Z');
    }

    chars
}

/// Tranform encoded text to uppercase and check for errors
fn prepare_decode(encoded: &str) -> Result<Vec<char>, &'static str> {
    if encoded.len() % 2 != 0 {
        return Err("encoded text must have a len % 2 == 0");
    }
    if encoded.contains('J') {
        return Err("encoded text must not contain 'J'");
    }
    Ok(encoded.to_uppercase().chars().collect())
}

impl Playfair {
    pub fn new(key_str: &str) -> Self {
        assert_eq!(25, key_str.len(), "Incorrect len for key: {}", key_str);

        let mut key = [['a'; 5]; 5];

        for (i, c) in key_str.chars().enumerate() {
            let (row, col) = (i / 5 as usize, i % 5 as usize);
            key[row][col] = c;
        }

        Self { key }
    }

    /// Lookup (row, col) of a char
    fn lookup(&self, target: char) -> Option<(usize, usize)> {
        for (rownum, row) in self.key.iter().enumerate() {
            for (colnum, c) in row.iter().enumerate() {
                if *c == target {
                    return Some((rownum, colnum));
                }
            }
        }
        None
    }

    /// Calculate wrapped position
    fn char_at(&self, row: usize, col: usize) -> char {
        self.key[row % 5][col % 5]
    }

    /// Returns None if any of the pair is not found in the table; Assumes that input will not contain 'J'
    fn encode_pair(&self, pair: (char, char)) -> Option<(char, char)> {
        let (r0, c0) = self.lookup(pair.0)?;
        let (r1, c1) = self.lookup(pair.1)?;

        Some(if r0 == r1 {
            (self.char_at(r0 + 1, c0), self.char_at(r1 + 1, c1))
        } else if c0 == c1 {
            (self.char_at(r0, c0 + 1), self.char_at(r1, c1 + 1))
        } else {
            (self.char_at(r0, c1), self.char_at(r1, c0))
        })
    }

    pub fn encode(&self, text: &str) -> String {
        let letters = prepare(text);
        let mut encoded = String::with_capacity(letters.len());
        letters
            .chunks_exact(2)
            .map(|chunk| {
                let pair = (chunk[0], chunk[1]);
                self.encode_pair(pair)
            })
            .for_each(|op_char| {
                let (c0, c1) = op_char.expect("Invalid pair");
                encoded.push(c0);
                encoded.push(c1);
            });

        encoded
    }

    fn decode_pair(&self, pair: (char, char)) -> Option<(char, char)> {
        let (r0, c0) = self.lookup(pair.0)?;
        let (r1, c1) = self.lookup(pair.1)?;

        Some(if r0 == r1 {
            (self.char_at(r0 - 1, c0), self.char_at(r1 - 1, c1))
        } else if c0 == c1 {
            (self.char_at(r0, c0 - 1), self.char_at(r1, c1 - 1))
        } else {
            (self.char_at(r0, c1), self.char_at(r1, c0))
        })
    }

    pub fn decode(&self, encoded: &str) -> String {
        let letters = prepare_decode(encoded).unwrap();
        let mut plain = String::with_capacity(letters.len());
        letters
            .chunks_exact(2)
            .map(|chunk| {
                let pair = (chunk[0], chunk[1]);
                self.decode_pair(pair)
            })
            .for_each(|op_pair| {
                let (c0, c1) = op_pair.expect("invalid pair");
                plain.push(c0);
                plain.push(c1);
            });

        plain
    }
}

#[cfg(test)]
mod tests {

    use super::*;
    #[test]
    fn test_prepare() {
        assert_eq!("PLAINZ", prepare("plain").iter().collect::<String>());
        assert_eq!("AOOC", prepare("AOOC").iter().collect::<String>());
        assert_eq!("AOOXOC", prepare("AOOOC").iter().collect::<String>());
        assert_eq!(
            "VEEDAXAEKXKPYZ",
            prepare("VEEDAAEKKPY").iter().collect::<String>()
        );
    }

    #[test]
    fn test_encode() {
        let encoder = Playfair::new("PLAYFIREXMBCDGHKNOQSTUVWZ");
        assert_eq!("ZGRUMDPV", encoder.encode("WHITEHAT"));

        assert_eq!(
            "YDQEQGASQGDKVTMKLDQEVTDKVT",
            encoder.encode("AGOODFOODBOOKISACOOKBOOK")
        );

        let encoder = Playfair::new("OZAKDIREXMBCVGHYNPQSTUFWL");
        assert_eq!(
            "UZMENRPDBKIMMENUIMBV",
            encoder.encode("TODAYISAGOODDAYTODIE")
        );
    }

    #[test]
    fn test_decode() {
        let encoder = Playfair::new("PLAYFIREXMBCDGHKNOQSTUVWZ");
        assert_eq!("WHITEHAT", encoder.decode("ZGRUMDPV"));

        assert_eq!(
            "AGOXODFOODBOOKISACOXOKBOOK",
            encoder.decode("YDQEQGASQGDKVTMKLDQEVTDKVT")
        );

        let encoder = Playfair::new("OZAKDIREXMBCVGHYNPQSTUFWL");
        assert_eq!(
            "TODAYISAGOODDAYTODIE",
            encoder.decode("UZMENRPDBKIMMENUIMBV")
        );
    }
}
