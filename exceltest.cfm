<!--
=============================================================================
Tutorial 05

This code sample shows how to export data to Excel file (1) in ColdFusion and
format the cells. The Excel file has multiple worksheets (2).
The first sheet is filled with data (3) and the cells are formatted (4).
=============================================================================
-->

<!-- Constants Classes -->
<cfobject type="java" class="EasyXLS.Constants.DataType" name="DataType" action="CREATE">
<cfobject type="java" class="EasyXLS.Constants.Border" name="Border" action="CREATE">
<cfobject type="java" class="EasyXLS.Constants.Alignment" name="Alignment" action="CREATE">
<cfobject type="java" class="java.awt.Color" name="Color" action="CREATE">

Tutorial 05<br>
----------<br>


<!-- Create an instance of the class that exports Excel files (1) -->
<cfobject type="java" class="EasyXLS.ExcelDocument" name="workbook" action="CREATE">

<!-- Create two sheets (2) -->
<cfset ret = workbook.easy_addWorksheet("First tab")>
<cfset ret = workbook.easy_addWorksheet("Second tab")>

<!-- Get the table of data for the first worksheet (3) -->
<cfset xlsFirstTable = workbook.easy_getSheetAt(0).easy_getExcelTable()>

<!-- Create the formatting style for the header -->
<cfobject type="java" class="EasyXLS.ExcelStyle" name="xlsStyleHeader" action="CREATE">
<cfset xlsStyleHeader.setFont("Verdana")>
<cfset xlsStyleHeader.setFontSize(8)>
<cfset xlsStyleHeader.setItalic(true)>
<cfset xlsStyleHeader.setBold(true)>
<cfset xlsStyleHeader.setForeground(Color.yellow)>
<cfset xlsStyleHeader.setBackground(Color.black)>
<cfset xlsStyleHeader.setBorderColors(Color.gray, Color.gray, Color.gray, Color.gray)>
<cfset xlsStyleHeader.setBorderStyles(Border.BORDER_MEDIUM, Border.BORDER_MEDIUM,
                                      Border.BORDER_MEDIUM, Border.BORDER_MEDIUM)>
<cfset xlsStyleHeader.setHorizontalAlignment(Alignment.ALIGNMENT_CENTER)>
<cfset xlsStyleHeader.setVerticalAlignment(Alignment.ALIGNMENT_BOTTOM)>
<cfset xlsStyleHeader.setWrap(true)>
<cfset xlsStyleHeader.setDataType(DataType.STRING)>

<!-- Add data in cells for report header -->
<cfloop from="0" to="4" index="column">
    <cfset xlsFirstTable.easy_getCell(0, evaluate(column)).setValue("Column " & evaluate(column + 1))>
    <cfset xlsFirstTable.easy_getCell(0, evaluate(column)).setStyle(xlsStyleHeader)>
</cfloop>
<cfset ret = xlsFirstTable.easy_getRowAt(0).setHeight(30)>

<!-- Create a formatting style for cells (4) -->
<cfobject type="java" class="EasyXLS.ExcelStyle" name="xlsStyleData" action="CREATE">
<cfset xlsStyleData.setHorizontalAlignment(Alignment.ALIGNMENT_LEFT)>
<cfset xlsStyleData.setForeground(Color.lightGray)>
<cfset xlsStyleData.setWrap(false)>
<cfset xlsStyleData.setDataType(DataType.STRING)>

<!-- Add data in cells for report values  -->
<cfloop from="0" to="99" index="row">
    <cfloop from="0" to="4" index="column">
        <cfset xlsFirstTable.easy_getCell(evaluate(row + 1), evaluate(column)).setValue(
                "Data " & evaluate(row + 1) & ", " & evaluate(column + 1))>
        <cfset xlsFirstTable.easy_getCell(evaluate(row + 1), evaluate(column)).setStyle(xlsStyleData)>
    </cfloop>
</cfloop>

<!-- Set column widths -->
<cfset xlsFirstTable.setColumnWidth(0, 70)>
<cfset xlsFirstTable.setColumnWidth(1, 900)>
<cfset xlsFirstTable.setColumnWidth(2, 70)>
<cfset xlsFirstTable.setColumnWidth(3, 100)>
<cfset xlsFirstTable.setColumnWidth(4, 70)>

<!-- Export the Excel file -->
Writing file C:\Samples\Tutorial05 - format Excel cells.xlsx<br>
<cfset ret = workbook.easy_WriteXLSXFile("C:\Samples\Tutorial05 - format Excel cells.xlsx")>

<!-- Confirm export of Excel file -->
<cfset sError = workbook.easy_getError()>
<cfif (sError is "")>
    <cfoutput>
        File successfully created.
    </cfoutput>
<cfelse>
    <cfoutput>
        Error encountered: #sError#
    </cfoutput>
</cfif>

<!-- Dispose memory -->
<cfset workbook.Dispose()>

