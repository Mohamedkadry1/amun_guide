import PyPDF2

pdf_path = r'd:\project\amun_guide\API_Documentation.pdf'
pdf = PyPDF2.PdfReader(pdf_path)

# استخراج كل النص
full_text = ''
for page_num, page in enumerate(pdf.pages):
    text = page.extract_text()
    full_text += f"\n=== PAGE {page_num + 1} ===\n{text}"

print(full_text)
