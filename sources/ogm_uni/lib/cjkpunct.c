/*
 * Handling Cjk (Chinese Japanese Corean) punctuations
 * Copyright (c) 2009 Pertimm by Patrick Constant
 * Dev : November 2009
 * Version 1.0
 */
#include <loguni.h>

PUBLIC(int) OgUniCjkIsPunct(int c)
{
  /** CJK style punctuation **/
  if ((0x3000 <= c && c <= 0x303f) || (0xfe30 <= c && c <= 0xfe4f))
  {
    return (1);
  }

  switch (c)
  {

    /** <!--http://www.unicode.org/charts/PDF/U3000.pdf--> */

    case 0x3001: /** IDEOGRAPHIC COMMA 、*/
    case 0x3002: /** IDEOGRAPHIC FULL STOP 。 */
    case 0x3003: /** DITTO MARK 〃 */
    case 0x3004: /** APANESE INDUSTRIAL STANDARD SYMBOL 〄  */
    case 0x3005: /** IDEOGRAPHIC ITERATION MARK 々 */
    case 0x3006: /** IDEOGRAPHIC CLOSING MARK 〆 */
    case 0x3008: /** LEFT ANGLE BRACKET 〈 */
    case 0x3009: /** LEFT ANGLE BRACKET 〉 */
    case 0x300A: /** LEFT DOUBLE ANGLE BRACKET 《 */
    case 0x300B: /** RIGHT DOUBLE ANGLE BRACKET 》 */
    case 0x300C: /** LEFT CORNER BRACKET 「 */
    case 0x300D: /** RIGHT CORNER BRACKET 」 */
    case 0x300E: /** LEFT WHITE CORNER BRACKET 『 */
    case 0x300F: /** RIGHT WHITE CORNER BRACKET 』 */
    case 0x3010: /** LEFT BLACK LENTICULAR BRACKET 【  */
    case 0x3011: /** RIGHT BLACK LENTICULAR BRACKET 】  */
    case 0x3012: /** POSTAL MARK 〒  */
    case 0x3013: /** GETA MARK 〓  */
    case 0x3014: /** LEFT TORTOISE SHELL BRACKET 〔  */
    case 0x3015: /** RIGHT TORTOISE SHELL BRACKET 〕  */
    case 0x3016: /** LEFT WHITE LENTICULAR BRACKET 〖  */
    case 0x3017: /** RIGHT WHITE LENTICULAR BRACKET  〗  */
    case 0x3018: /** LEFT WHITE TORTOISE SHELL BRACKET 〘  */
    case 0x3019: /** RIGHT WHITE TORTOISE SHELL BRACKET  〙 */
    case 0x301A: /** LEFT WHITE SQUARE BRACKET  〚 */
    case 0x301B: /** RIGHT WHITE SQUARE BRACKET  〛 */
    case 0x301C: /** WAVE DASH  〜 */
    case 0x301D: /** REVERSED DOUBLE PRIME QUOTATION MARK 〝 */
    case 0x301E: /** DOUBLE PRIME QUOTATION MARK  〞*/
    case 0x301F: /** LOW DOUBLE PRIME QUOTATION MARK  〟 */
    case 0x3020: /** POSTAL MARK FACE  〠  */
    case 0x302A: /** IDEOGRAPHIC LEVEL TONE MARK 〪   */
    case 0x302B: /** IDEOGRAPHIC RISING TONE MARK 〫   */
    case 0x302C: /** IDEOGRAPHIC DEPARTING TONE MARK  〬   */
    case 0x302D: /** IDEOGRAPHIC ENTERING TONE MARK  〭   */
    case 0x302E: /** HANGUL SINGLE DOT TONE MARK   〮   */
    case 0x302F: /** HANGUL DOUBLE DOT TONE MARK   〯  */
    case 0x3030: /** WAVY DASH  〰  */
    case 0x3031: /** VERTICAL KANA REPEAT MARK  〱  */
    case 0x3032: /** VERTICAL KANA REPEAT WITH VOICED SOUND MARK  〲  */
    case 0x3033: /** VERTICAL KANA REPEAT MARK UPPER HALF  〳 */
    case 0x3034: /** VERTICAL KANA REPEAT WITH VOICED SOUND MARK UPPER HALF 〴 */
    case 0x3035: /** VERTICAL KANA REPEAT MARK LOWER HALF 〵 */
    case 0x3036: /** CIRCLED POSTAL MARK 〶  */
    case 0x3037: /** IDEOGRAPHIC TELEGRAPH LINE FEED SEPARATOR SYMBOL 〷  */
    case 0x303B: /** VERTICAL IDEOGRAPHIC ITERATION MARK 〻 */
    case 0x303C: /** MASU MARK 〼 */
    case 0x303D: /** PART ALTERNATION MARK 〽 */
    case 0x303E: /** IDEOGRAPHIC VARIATION INDICATOR  */
    case 0x303F: /** IDEOGRAPHIC HALF FILL SPACE 〿 */

      /** http://www.unicode.org/charts/PDF/UFE30.pdf */

    case 0xFE30: /** PRESENTATION FORM FOR VERTICAL TWO DOT LEADER ︰ */
    case 0xFE31: /** PRESENTATION FORM FOR VERTICAL EM DASH ︱ */
    case 0xFE32: /** PRESENTATION FORM FOR VERTICAL EN DASH ︲  */
    case 0xFE33: /** PRESENTATION FORM FOR VERTICAL LOW LINE ︳*/
    case 0xFE34: /** PRESENTATION FORM FOR VERTICAL WAVY LOW LINE ︴*/
    case 0xFE35: /** PRESENTATION FORM FOR VERTICAL LEFT PARENTHESIS ︵ */
    case 0xFE36: /** PRESENTATION FORM FOR VERTICAL RIGHT PARENTHESIS ︶ */
    case 0xFE37: /** PRESENTATION FORM FOR VERTICAL LEFT CURLY BRACKET ︷ */
    case 0xFE38: /** PRESENTATION FORM FOR VERTICAL RIGHT CURLY BRACKET ︸ */
    case 0xFE39: /** PRESENTATION FORM FOR VERTICAL LEFT TORTOISE SHELL BRACKET ︹ */
    case 0xFE3A: /** PRESENTATION FORM FOR VERTICAL RIGHT TORTOISE SHELL BRACKET ︺ */
    case 0xFE3B: /** PRESENTATION FORM FOR VERTICAL LEFT BLACK LENTICULAR BRACKET ︻ */
    case 0xFE3C: /** PRESENTATION FORM FOR VERTICAL RIGHT BLACK LENTICULAR BRACKET ︼ */
    case 0xFE3D: /** PRESENTATION FORM FOR VERTICAL LEFT DOUBLE ANGLE BRACKET ︽ */
    case 0xFE3E: /** PRESENTATION FORM FOR VERTICAL RIGHT DOUBLE ANGLE BRACKET ︾ */
    case 0xFE3F: /** PRESENTATION FORM FOR VERTICAL LEFT ANGLE BRACKET ︿ */
    case 0xFE40: /** PRESENTATION FORM FOR VERTICAL RIGHT ANGLE BRACKET ﹀ */
    case 0xFE41: /** PRESENTATION FORM FOR VERTICAL LEFT CORNER BRACKET ﹁ */
    case 0xFE42: /** PRESENTATION FORM FOR VERTICAL RIGHT CORNER BRACKET ﹂ */
    case 0xFE43: /** PRESENTATION FORM FOR VERTICAL LEFT WHITE CORNER BRACKET ﹃ */
    case 0xFE44: /** PRESENTATION FORM FOR VERTICAL RIGHT WHITE CORNER BRACKET ﹄ */
    case 0xFE45: /** SESAME DOT ﹅ */
    case 0xFE46: /** WHITE SESAME DOT ﹆ */
    case 0xFE47: /** PRESENTATION FORM FOR VERTICAL LEFT SQUARE BRACKET ﹇ */
    case 0xFE48: /** PRESENTATION FORM FOR VERTICAL RIGHT SQUARE BRACKET ﹈ */
    case 0xFE49: /** DASHED OVERLINE ﹉ */
    case 0xFE4A: /** CENTRELINE OVERLINE ﹊ */
    case 0xFE4B: /** WAVY OVERLINE ﹋ */
    case 0xFE4C: /** DOUBLE WAVY OVERLINE ﹌ */
    case 0xFE4D: /** DASHED LOW LINE ﹍ */
    case 0xFE4E: /** CENTRELINE LOW LINE ﹎ */
    case 0xFE4F: /** WAVY LOW LINE ﹏ */
      return (1);
  }
  return (0);
}

