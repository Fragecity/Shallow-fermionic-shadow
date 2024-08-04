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
	(Sqrt[\[Pi]/2] (1 - 
   I Erfi[(a - I t \[Beta])/(Sqrt[2] Sqrt[t])]))/(Sqrt[t] \[Beta])
	"""

    output_text = replace_bracketed_strings(input_text)
    print(output_text)
