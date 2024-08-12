import re


def replace_bracketed_strings(text):
    pattern = re.compile(r"\\\[([A-Za-z]+)\]")

    def to_lowercase(match):
        return match.group(1).lower()

    res = pattern.sub(to_lowercase, text)
    # print(res)
    return res.replace("Sin", "sin").replace("Cos", "cos").replace("E^", "e^")


# Example usage
if __name__ == "__main__":
    input_text = """
	1/4 (Cos[(k \[Pi])/(
     2 n)] (Csc[((k - l) \[Pi])/(2 n)] + Csc[((k + l) \[Pi])/(2 n)]) -
    Csc[((k - l) \[Pi])/(
     2 n)] Sin[((k + 2 l (-1 + n) + n - 2 k n) \[Pi])/(2 n)] - 
   Csc[((k + l) \[Pi])/(
     2 n)] Sin[((k + 2 l + n - 2 k n - 2 l n) \[Pi])/(2 n)])
	"""

    output_text = replace_bracketed_strings(input_text)
    print(output_text)
