To start using the IST-UL_Project_Report LaTeX template, just open and modify your data in the following files:
-------------------------------------
1. IST—UL-Project-Report-Preamble.tex
Select the ‘main’ language of your Report in the line that loads the package ‘babel’:

	\usepackage[main=english,portuguese]{babel}
	
	or 
	\usepackage[english,main=portuguese]{babel}
	
The Report document will then automagically modify all the adequate keywords, titles, captions, etc. according to the selected language.

Later, you may modify parameters or include other packages if deemed necessary.

----------------------------------------
2. IST-UL-Project—Report-Front_Cover.tex
In this document insert your data (group number, student names and IDs, titles, date, etc.).

----------------------------------------
3. IST-ULProject-Report-Main_Document.tex
The content of your Report will be written in this file 

Do not modify the ‘header’ in all the documents as they contain compile directives. 
After compilation it produces a main.pdf document that you can copy and rename. 

You can upload pictures to folder "pictures" and reference them in your document as exemplified.

----------------------------------------
4. IST-UL-Project-Report_bib_DB.bib
This file is the Bibliography database. Just replace it with your own, and if the name is different, just modify the corresponding line in in the main document ‘IST-ULProject-Report-Main_Documentt.tex’:

	\bibliography{./IST-UL-Project-Report_bib_DB}

#####################

Enjoy

Rui Santos Cruz