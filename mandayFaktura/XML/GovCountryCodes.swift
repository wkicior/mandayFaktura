//
//  GovCountryCodes.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 07/01/2024.
//  Copyright © 2024 Wojciech Kicior. All rights reserved.
//

import Foundation

class GovCountryCodes {
    private static let namesPlToCodes = [
        "AFGANISTAN": "AF",
        "ALAND ISLANDS": "AX",
        "ALBANIA": "AL",
        "ALGIERIA": "DZ",
        "ANDORA": "AD",
        "ANGOLA": "AO",
        "ANGUILLA": "AI",
        "ANTARKTYDA": "AQ",
        "ANTIGUA I BARBUDA": "AG",
        "ANTYLE HOLENDERSKIE": "AN",
        "ARABIA SAUDYJSKA": "SA",
        "ARGENTYNA": "AR",
        "ARMENIA": "AM",
        "ARUBA": "AW",
        "AUSTRALIA": "AU",
        "AUSTRIA": "AT",
        "AZERBEJDŻAN": "AZ",
        "BAHAMY": "BS",
        "BAHRAJN": "BH",
        "BANGLADESZ": "BD",
        "BARBADOS": "BB",
        "BELGIA": "BE",
        "BELIZE": "BZ",
        "BENIN": "BJ",
        "BERMUDY": "BM",
        "BHUTAN": "BT",
        "BIAŁORUŚ": "BY",
        "BOLIWIA": "BO",
        "BONAIRE, SINT EUSTATIUS I SABA": "BQ",
        "BOŚNIA I HERCEGOWINA": "BA",
        "BOTSWANA": "BW",
        "BRAZYLIA": "BR",
        "BRUNEI DARUSSALAM": "BN",
        "BRYTYJSKIE TERYTORIUM OCEANU INDYJSKIEGO": "IO",
        "BUŁGARIA": "BG",
        "BURKINA FASO": "BF",
        "BURUNDI": "BI",
        "CEUTA": "XC",
        "CHILE": "CL",
        "CHINY": "CN",
        "CHORWACJA": "HR",
        "CURAÇAO": "CW",
        "CYPR": "CY",
        "CZAD": "TD",
        "CZARNOGÓRA": "ME",
        "DANIA": "DK",
        "DOMINIKA": "DM",
        "DOMINIKANA": "DO",
        "DŻIBUTI": "DJ",
        "EGIPT": "EG",
        "EKWADOR": "EC",
        "ERYTREA": "ER",
        "ESTONIA": "EE",
        "ETIOPIA": "ET",
        "FALKLANDY": "FK",
        "FIDŻI REPUBLIKA": "FJ",
        "FILIPINY": "PH",
        "FINLANDIA": "FI",
        "FRANCJA": "FR",
        "FRANCUSKIE TERYTORIUM POŁUDNIOWE": "TF",
        "GABON": "GA",
        "GAMBIA": "GM",
        "GHANA": "GH",
        "GIBRALTAR": "GI",
        "GRECJA": "GR",
        "GRENADA": "GD",
        "GRENLANDIA": "GL",
        "GRUZJA": "GE",
        "GUAM": "GU",
        "GUERNSEY": "GG",
        "GUJANA": "GY",
        "GUJANA FRANCUSKA": "GF",
        "GWADELUPA": "GP",
        "GWATEMALA": "GT",
        "GWINEA": "GN",
        "GWINEA RÓWNIKOWA": "GQ",
        "GWINEA-BISSAU": "GW",
        "HAITI": "HT",
        "HISZPANIA": "ES",
        "HONDURAS": "HN",
        "HONGKONG": "HK",
        "INDIE": "IN",
        "INDONEZJA": "ID",
        "IRAK": "IQ",
        "IRAN": "IR",
        "IRLANDIA": "IE",
        "ISLANDIA": "IS",
        "IZRAEL": "IL",
        "JAMAJKA": "JM",
        "JAPONIA": "JP",
        "JEMEN": "YE",
        "JERSEY": "JE",
        "JORDANIA": "JO",
        "KAJMANY": "KY",
        "KAMBODŻA": "KH",
        "KAMERUN": "CM",
        "KANADA": "CA",
        "KATAR": "QA",
        "KAZACHSTAN": "KZ",
        "KENIA": "KE",
        "KIRGISTAN": "KG",
        "KIRIBATI": "KI",
        "KOLUMBIA": "CO",
        "KOMORY": "KM",
        "KONGO": "CG",
        "KONGO, REPUBLIKA DEMOKRATYCZNA": "CD",
        "KOREAŃSKA REPUBLIKA LUDOWO-DEMOKRATYCZNA": "KP",
        "KOSOWO": "XK",
        "KOSTARYKA": "CR",
        "KUBA": "CU",
        "KUWEJT": "KW",
        "LAOS": "LA",
        "LESOTHO": "LS",
        "LIBAN": "LB",
        "LIBERIA": "LR",
        "LIBIA": "LY",
        "LIECHTENSTEIN": "LI",
        "LITWA": "LT",
        "ŁOTWA": "LV",
        "LUKSEMBURG": "LU",
        "MACEDONIA": "MK",
        "MADAGASKAR": "MG",
        "MAJOTTA": "YT",
        "MAKAU": "MO",
        "MALAWI": "MW",
        "MALEDIWY": "MV",
        "MALEZJA": "MY",
        "MALI": "ML",
        "MALTA": "MT",
        "MARIANY PÓŁNOCNE": "MP",
        "MAROKO": "MA",
        "MARTYNIKA": "MQ",
        "MAURETANIA": "MR",
        "MAURITIUS": "MU",
        "MEKSYK": "MX",
        "MELILLA": "XL",
        "MIKRONEZJA": "FM",
        "MINOR": "UM",
        "MOŁDOWA": "MD",
        "MONAKO": "MC",
        "MONGOLIA": "MN",
        "MONTSERRAT": "MS",
        "MOZAMBIK": "MZ",
        "MYANMAR (BURMA)": "MM",
        "NAMIBIA": "NA",
        "NAURU": "NR",
        "NEPAL": "NP",
        "NIDERLANDY (HOLANDIA)": "NL",
        "NIEMCY": "DE",
        "NIGER": "NE",
        "NIGERIA": "NG",
        "NIKARAGUA": "NI",
        "NIUE": "NU",
        "NORFOLK": "NF",
        "NORWEGIA": "NO",
        "NOWA KALEDONIA": "NC",
        "NOWA ZELANDIA": "NZ",
        "OKUPOWANE TERYTORIUM PALESTYNY": "PS",
        "OMAN": "OM",
        "PAKISTAN": "PK",
        "PALAU": "PW",
        "PANAMA": "PA",
        "PAPUA NOWA GWINEA": "PG",
        "PARAGWAJ": "PY",
        "PERU": "PE",
        "PITCAIRN": "PN",
        "POLINEZJA FRANCUSKA": "PF",
        "POLSKA": "PL",
        "POŁUDNIOWA GEORGIA I POŁUD.WYSPY SANDWICH": "GS",
        "PORTUGALIA": "PT",
        "PORTORYKO": "PR",
        "REP.ŚRODKOWOAFRYKAŃSKA": "CF",
        "REPUBLIKA CZESKA": "CZ",
        "REPUBLIKA KOREI": "KR",
        "REPUBLIKA POŁUDNIOWEJ AFRYKI": "ZA",
        "REUNION": "RE",
        "ROSJA": "RU",
        "RUMUNIA": "RO",
        "RWANDA": "RW",
        "SAHARA ZACHODNIA": "EH",
        "SAINT BARTHELEMY": "BL",
        "SAINT KITTS I NEVIS": "KN",
        "SAINT LUCIA": "LC",
        "SAINT MARTIN": "MF",
        "SAINT VINCENT I GRENADYNY": "VC",
        "SALWADOR": "SV",
        "SAMOA": "WS",
        "SAMOA AMERYKAŃSKIE": "AS",
        "SAN MARINO": "SM",
        "SENEGAL": "SN",
        "SERBIA": "RS",
        "SESZELE": "SC",
        "SIERRA LEONE": "SL",
        "SINGAPUR": "SG",
        "SŁOWACJA": "SK",
        "SŁOWENIA": "SI",
        "SOMALIA": "SO",
        "SRI LANKA": "LK",
        "SAINT PIERRE I MIQUELON": "PM",
        "STANY ZJEDNOCZONE AMERYKI": "US",
        "SUAZI": "SZ",
        "SUDAN": "SD",
        "SUDAN POŁUDNIOWY": "SS",
        "SURINAM": "SR",
        "SVALBARD I JAN MAYEN": "SJ",
        "ŚWIĘTA HELENA": "SH",
        "SYRIA": "SY",
        "SZWAJCARIA": "CH",
        "SZWECJA": "SE",
        "TADŻYKISTAN": "TJ",
        "TAJLANDIA": "TH",
        "TAJWAN": "TW",
        "TANZANIA": "TZ",
        "TOGO": "TG",
        "TOKELAU": "TK",
        "TONGA": "TO",
        "TRYNIDAD I TOBAGO": "TT",
        "TUNEZJA": "TN",
        "TURCJA": "TR",
        "TURKMENISTAN": "TM",
        "TUVALU": "TV",
        "UGANDA": "UG",
        "UKRAINA": "UA",
        "URUGWAJ": "UY",
        "UZBEKISTAN": "UZ",
        "VANUATU": "VU",
        "WALLIS I FUTUNA": "WF",
        "WATYKAN": "VA",
        "WĘGRY": "HU",
        "WENEZUELA": "VE",
        "WIELKA BRYTANIA": "GB",
        "WIETNAM": "VN",
        "WŁOCHY": "IT",
        "WSCHODNI TIMOR": "TL",
        "WYBRZEŻE KOŚCI SŁONIOWEJ": "CI",
        "WYSPA BOUVETA": "BV",
        "WYSPA BOŻEGO NARODZENIA": "CX",
        "WYSPA MAN": "IM",
        "WYSPA SINT MAARTEN (CZĘŚĆ HOLENDERSKA WYSPY)": "SX",
        "WYSPY COOKA": "CK",
        "WYSPY DZIEWICZE-USA": "VI",
        "WYSPY DZIEWICZE-W.B.": "VG",
        "WYSPY HEARD I MCDONALD": "HM",
        "WYSPY KOKOSOWE (KEELINGA)": "CC",
        "WYSPY MARSHALLA": "MH",
        "WYSPY OWCZE": "FO",
        "WYSPY SALOMONA": "SB",
        "WYSPY ŚWIĘTEGO TOMASZA I KSIĄŻĘCA": "ST",
        "WYSPY TURKS I CAICOS": "TC",
        "ZAMBIA": "ZM",
        "ZIELONY PRZYLĄDEK": "CV",
        "ZIMBABWE": "ZW",
        "ZJEDNOCZONE EMIRATY ARABSKIE": "AE",
        "ZJEDNOCZONE KRÓLESTWO (IRLANDIA PÓŁNOCNA)": "XI",
        
    ]
    
    // AI translated
    private static let namesEnToCodes = [
        "AFGHANISTAN": "AF",
        "ALAND ISLANDS": "AX",
        "ALBANIA": "AL",
        "ALGERIA": "DZ",
        "ANDORRA": "AD",
        "ANGOLA": "AO",
        "ANGUILLA": "AI",
        "ANTARCTICA": "AQ",
        "ANTIGUA AND BARBUDA": "AG",
        "NETHERLANDS ANTILLES": "AN",
        "SAUDI ARABIA": "SA",
        "ARGENTINA": "AR",
        "ARMENIA": "AM",
        "ARUBA": "AW",
        "AUSTRALIA": "AU",
        "AUSTRIA": "AT",
        "AZERBAIJAN": "AZ",
        "BAHAMAS": "BS",
        "BAHRAIN": "BH",
        "BANGLADESH": "BD",
        "BARBADOS": "BB",
        "BELGIUM": "BE",
        "BELIZE": "BZ",
        "BENIN": "BJ",
        "BERMUDA": "BM",
        "BHUTAN": "BT",
        "BELARUS": "BY",
        "BOLIVIA": "BO",
        "BONAIRE, SINT EUSTATIUS AND SABA": "BQ",
        "BOSNIA AND HERZEGOVINA": "BA",
        "BOTSWANA": "BW",
        "BRAZIL": "BR",
        "BRUNEI DARUSSALAM": "BN",
        "BRITISH INDIAN OCEAN TERRITORY": "IO",
        "BULGARIA": "BG",
        "BURKINA FASO": "BF",
        "BURUNDI": "BI",
        "CEUTA": "XC",
        "CHILE": "CL",
        "CHINA": "CN",
        "CROATIA": "HR",
        "CURAÇAO": "CW",
        "CYPRUS": "CY",
        "CHAD": "TD",
        "MONTENEGRO": "ME",
        "DENMARK": "DK",
        "DOMINICA": "DM",
        "DOMINICAN REPUBLIC": "DO",
        "DJIBOUTI": "DJ",
        "EGYPT": "EG",
        "ECUADOR": "EC",
        "ERITREA": "ER",
        "ESTONIA": "EE",
        "ETHIOPIA": "ET",
        "FALKLAND ISLANDS": "FK",
        "FIJI REPUBLIC": "FJ",
        "PHILIPPINES": "PH",
        "FINLAND": "FI",
        "FRANCE": "FR",
        "FRENCH SOUTHERN TERRITORIES": "TF",
        "GABON": "GA",
        "GAMBIA": "GM",
        "GHANA": "GH",
        "GIBRALTAR": "GI",
        "GREECE": "GR",
        "GRENADA": "GD",
        "GREENLAND": "GL",
        "GEORGIA": "GE",
        "GUAM": "GU",
        "GUERNSEY": "GG",
        "GUYANA": "GY",
        "FRENCH GUIANA": "GF",
        "GUADELOUPE": "GP",
        "GUATEMALA": "GT",
        "GUINEA": "GN",
        "EQUATORIAL GUINEA": "GQ",
        "GUINEA-BISSAU": "GW",
        "HAITI": "HT",
        "SPAIN": "ES",
        "HONDURAS": "HN",
        "HONG KONG": "HK",
        "INDIA": "IN",
        "INDONESIA": "ID",
        "IRAQ": "IQ",
        "IRAN": "IR",
        "IRELAND": "IE",
        "ICELAND": "IS",
        "ISRAEL": "IL",
        "JAMAICA": "JM",
        "JAPAN": "JP",
        "YEMEN": "YE",
        "JERSEY": "JE",
        "JORDAN": "JO",
        "CAYMAN ISLANDS": "KY",
        "CAMBODIA": "KH",
        "CAMEROON": "CM",
        "CANADA": "CA",
        "QATAR": "QA",
        "KAZAKHSTAN": "KZ",
        "KENYA": "KE",
        "KYRGYZSTAN": "KG",
        "KIRIBATI": "KI",
        "COLOMBIA": "CO",
        "COMOROS": "KM",
        "CONGO": "CG",
        "DEMOCRATIC REPUBLIC OF THE CONGO": "CD",
        "DEMOCRATIC PEOPLE'S REPUBLIC OF KOREA": "KP",
        "KOSOVO": "XK",
        "COSTA RICA": "CR",
        "CUBA": "CU",
        "KUWAIT": "KW",
        "LAOS": "LA",
        "LESOTHO": "LS",
        "LEBANON": "LB",
        "LIBERIA": "LR",
        "LIBYA": "LY",
        "LIECHTENSTEIN": "LI",
        "LITHUANIA": "LT",
        "LATVIA": "LV",
        "LUXEMBOURG": "LU",
        "MACEDONIA": "MK",
        "MADAGASCAR": "MG",
        "MAYOTTE": "YT",
        "MACAO": "MO",
        "MALAWI": "MW",
        "MALDIVES": "MV",
        "MALAYSIA": "MY",
        "MALI": "ML",
        "MALTA": "MT",
        "NORTHERN MARIANA ISLANDS": "MP",
        "MOROCCO": "MA",
        "MARTINIQUE": "MQ",
        "MAURITANIA": "MR",
        "MAURITIUS": "MU",
        "MEXICO": "MX",
        "MELILLA": "XL",
        "MICRONESIA": "FM",
        "MINOR": "UM",
        "MOLDOVA": "MD",
        "MONACO": "MC",
        "MONGOLIA": "MN",
        "MONTSERRAT": "MS",
        "MOZAMBIQUE": "MZ",
        "MYANMAR (BURMA)": "MM",
        "NAMIBIA": "NA",
        "NAURU": "NR",
        "NEPAL": "NP",
        "NETHERLANDS (HOLLAND)": "NL",
        "GERMANY": "DE",
        "NIGER": "NE",
        "NIGERIA": "NG",
        "NICARAGUA": "NI",
        "NIUE": "NU",
        "NORFOLK ISLAND": "NF",
        "NORWAY": "NO",
        "NEW CALEDONIA": "NC",
        "NEW ZEALAND": "NZ",
        "OCCUPIED PALESTINIAN TERRITORY": "PS",
        "OMAN": "OM",
        "PAKISTAN": "PK",
        "PALAU": "PW",
        "PANAMA": "PA",
        "PAPUA NEW GUINEA": "PG",
        "PARAGUAY": "PY",
        "PERU": "PE",
        "PITCAIRN": "PN",
        "FRENCH POLYNESIA": "PF",
        "POLAND": "PL",
        "SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS": "GS",
        "PORTUGAL": "PT",
        "PUERTO RICO": "PR",
        "CENTRAL AFRICAN REPUBLIC": "CF",
        "CZECH REPUBLIC": "CZ",
        "REPUBLIC OF KOREA": "KR",
        "REPUBLIC OF SOUTH AFRICA": "ZA",
        "REUNION": "RE",
        "RUSSIA": "RU",
        "ROMANIA": "RO",
        "RWANDA": "RW",
        "WESTERN SAHARA": "EH",
        "SAINT BARTHELEMY": "BL",
        "SAINT KITTS AND NEVIS": "KN",
        "SAINT LUCIA": "LC",
        "SAINT MARTIN": "MF",
        "SAINT VINCENT AND THE GRENADINES": "VC",
        "EL SALVADOR": "SV",
        "SAMOA": "WS",
        "AMERICAN SAMOA": "AS",
        "SAN MARINO": "SM",
        "SENEGAL": "SN",
        "SERBIA": "RS",
        "SEYCHELLES": "SC",
        "SIERRA LEONE": "SL",
        "SINGAPORE": "SG",
        "SLOVAKIA": "SK",
        "SLOVENIA": "SI",
        "SOMALIA": "SO",
        "SRI LANKA": "LK",
        "SAINT PIERRE AND MIQUELON": "PM",
        "UNITED STATES OF AMERICA": "US",
        "SWAZILAND": "SZ",
        "SUDAN": "SD",
        "SOUTH SUDAN": "SS",
        "SURINAME": "SR",
        "SVALBARD AND JAN MAYEN": "SJ",
        "SAINT HELENA": "SH",
        "SYRIA": "SY",
        "SWITZERLAND": "CH",
        "SWEDEN": "SE",
        "TAJIKISTAN": "TJ",
        "THAILAND": "TH",
        "TAIWAN": "TW",
        "TANZANIA": "TZ",
        "TOGO": "TG",
        "TOKELAU": "TK",
        "TONGA": "TO",
        "TRINIDAD AND TOBAGO": "TT",
        "TUNISIA": "TN",
        "TURKEY": "TR",
        "TURKMENISTAN": "TM",
        "TUVALU": "TV",
        "UGANDA": "UG",
        "UKRAINE": "UA",
        "URUGUAY": "UY",
        "UZBEKISTAN": "UZ",
        "VANUATU": "VU",
        "WALLIS AND FUTUNA": "WF",
        "VATICAN CITY": "VA",
        "HUNGARY": "HU",
        "VENEZUELA": "VE",
        "UNITED KINGDOM": "GB",
        "VIETNAM": "VN",
        "ITALY": "IT",
        "EAST TIMOR": "TL",
        "IVORY COAST": "CI",
        "BOUVET ISLAND": "BV",
        "CHRISTMAS ISLAND": "CX",
        "ISLE OF MAN": "IM",
        "SINT MAARTEN (DUTCH PART)": "SX",
        "COOK ISLANDS": "CK",
        "VIRGIN ISLANDS, U.S.": "VI",
        "BRITISH VIRGIN ISLANDS": "VG",
        "HEARD ISLAND AND MCDONALD ISLANDS": "HM",
        "COCOS (KEELING) ISLANDS": "CC",
        "MARSHALL ISLANDS": "MH",
        "FAROE ISLANDS": "FO",
        "SOLOMON ISLANDS": "SB",
        "SAO TOME AND PRINCIPE": "ST",
        "TURKS AND CAICOS ISLANDS": "TC",
        "ZAMBIA": "ZM",
        "CAPE VERDE": "CV",
        "ZIMBABWE": "ZW",
        "UNITED ARAB EMIRATES": "AE",
        "UNITED KINGDOM (NORTHERN IRELAND)": "XI"
    ]
    
    public static func getCodeByName(countryName: String) -> String? {
        return GovCountryCodes.namesPlToCodes[countryName.uppercased()] ?? GovCountryCodes.namesEnToCodes[countryName.uppercased()]
    }
}
