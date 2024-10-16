import Foundation

class UtilityFunctions {
    static func getLanguageCode(from language: String) -> String {
        switch language {
            case "Italiano":
                return "it"
            case "English":
                return "en"
            case "Spanish":
                return "es"
            case "French":
                return "fr"
            case "German":
                return "de"
            case "Russian":
                return "ru"
            case "Chinese":
                return "zh-CN"
            case "Japanese":
                return "ja"
            case "Korean":
                return "ko"
            default:
                return "en"
        }
    }
    
    

    static func parseTranslation(from html: String) -> String? {
        if let startRange = html.range(of: "<div class=\"result-container\">"),
        let endRange = html.range(of: "</div>", range: startRange.upperBound..<html.endIndex) {
            let translation = html[startRange.upperBound..<endRange.lowerBound]
            return decodeHTMLEntities(in: String(translation))
        }
        return nil
    }
    

    static func decodeHTMLEntities(in text: String) -> String {
        let htmlEntities: [String: String] = [
            "&quot;": "\"",
            "&apos;": "'",
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&#39;": "'",
            "&euro;": "€",
            "&bull;": "•",
            "&hellip;": "…",
            "&ndash;": "–",
            "&mdash;": "—", // em dash
            "&#8212;": "—", // numeric entity for em dash
            "&lsquo;": "‘",
            "&rsquo;": "’",
            "&ldquo;": "“",
            "&rdquo;": "”",
            "&nbsp;": " ",
            "&iexcl;": "¡",
            "&cent;": "¢",
            "&pound;": "£",
            "&curren;": "¤",
            "&yen;": "¥",
            "&brvbar;": "¦",
            "&sect;": "§",
            "&uml;": "¨",
            "&copy;": "©",
            "&ordf;": "ª",
            "&laquo;": "«",
            "&not;": "¬",
            "&shy;": "­",
            "&reg;": "®",
            "&macr;": "¯",
            "&deg;": "°",
            "&plusmn;": "±",
            "&sup2;": "²",
            "&sup3;": "³",
            "&acute;": "´",
            "&micro;": "µ",
            "&para;": "¶",
            "&middot;": "·",
            "&cedil;": "¸",
            "&sup1;": "¹",
            "&ordm;": "º",
            "&raquo;": "»",
            "&frac14;": "¼",
            "&frac12;": "½",
            "&frac34;": "¾",
            "&iquest;": "¿",
            "&Agrave;": "À",
            "&Aacute;": "Á",
            "&Acirc;": "Â",
            "&Atilde;": "Ã",
            "&Auml;": "Ä",
            "&Aring;": "Å",
            "&AElig;": "Æ",
            "&Ccedil;": "Ç",
            "&Egrave;": "È",
            "&Eacute;": "É",
            "&Ecirc;": "Ê",
            "&Euml;": "Ë",
            "&Igrave;": "Ì",
            "&Iacute;": "Í",
            "&Icirc;": "Î",
            "&Iuml;": "Ï",
            "&ETH;": "Ð",
            "&Ntilde;": "Ñ",
            "&Ograve;": "Ò",
            "&Oacute;": "Ó",
            "&Ocirc;": "Ô",
            "&Otilde;": "Õ",
            "&Ouml;": "Ö",
            "&times;": "×",
            "&Oslash;": "Ø",
            "&Ugrave;": "Ù",
            "&Uacute;": "Ú",
            "&Ucirc;": "Û",
            "&Uuml;": "Ü",
            "&Yacute;": "Ý",
            "&THORN;": "Þ",
            "&szlig;": "ß",
            "&agrave;": "à",
            "&aacute;": "á",
            "&acirc;": "â",
            "&atilde;": "ã",
            "&auml;": "ä",
            "&aring;": "å",
            "&aelig;": "æ",
            "&ccedil;": "ç",
            "&egrave;": "è",
            "&eacute;": "é",
            "&ecirc;": "ê",
            "&euml;": "ë",
            "&igrave;": "ì",
            "&iacute;": "í",
            "&icirc;": "î",
            "&iuml;": "ï",
            "&eth;": "ð",
            "&ntilde;": "ñ",
            "&ograve;": "ò",
            "&oacute;": "ó",
            "&ocirc;": "ô",
            "&otilde;": "õ",
            "&ouml;": "ö",
            "&divide;": "÷",
            "&oslash;": "ø",
            "&ugrave;": "ù",
            "&uacute;": "ú",
            "&ucirc;": "û",
            "&uuml;": "ü",
            "&yacute;": "ý",
            "&thorn;": "þ",
            "&yuml;": "ÿ",
            "&NewLine;": "\n"
        ]
        
        var decodedText = text
        for (entity, character) in htmlEntities {
            decodedText = decodedText.replacingOccurrences(of: entity, with: character)
        }
        
        return decodedText
    }

    
    
}

