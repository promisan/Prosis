<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfquery name="Batch"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   ShippingBatch
	WHERE  TransactionBatchNo = '#URL.ID#'
</cfquery>

<cfquery name="SearchResult"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Shipping
	WHERE  ShippingNo = '#URL.ID#'
	AND    OrgUnit = '#Listing.OrgUnit#'
	ORDER BY Location, Reference
</cfquery>

<cfquery name="Customer"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Organization
	WHERE  OrgUnit = '#Listing.OrgUnit#'
</cfquery>

<cf_pdf file="#SESSION.rootPath#\rptFiles\PDFLibrary\Shipping\#SESSION.acc#\#Customer.OrgUnitName#_#Batch.TransactionBatchNo#_.pdf" allowprinting="TRUE" allowcopy="TRUE" allowmodify="TRUE">

<cfoutput>
<cf_defaultHeader header="#Customer.OrgUnitName# - #Batch.TransactionBatchNo#" subtitle="Distribution list"> 
</cfoutput>

<!---
	
<cf_pdf_page size="LETTER">
	
   <cf_pdf_line x1="20" y1="780" x2="600" y2="780" width="1" color="808080" />
         
   
   <cf_pdf_line x1="20" y1="700" x2="600" y2="700" width="1" color="808080" />
			
		<cf_pdf_font file="#SESSION.rootpath#\\tools\\fonts\\Tahoma.ttf" name="tahoma">
	    <cf_pdf_table numcols="2" align="Left" columnwidth="90,340" border="1" bordercolor = "F6F6F6">
		
		<cfoutput>
		
		 <cf_pdf_cell>
		    <cf_pdf_text>Warehouse</cf_pdf_text>
		 </cf_pdf_cell>
         <cf_pdf_cell>
    		 <cf_pdf_text>#Batch.Warehouse# - #Batch.TransactionBatchNo#</cf_pdf_text>
		 </cf_pdf_cell>
		 
		 <cf_pdf_cell>
		    <cf_pdf_text>Officer</cf_pdf_text>
		 </cf_pdf_cell>
         <cf_pdf_cell>
    		 <cf_pdf_text>#Batch.OfficerFirstName# #Batch.OfficerLastName#</cf_pdf_text>
		 </cf_pdf_cell>
        
		 <cf_pdf_cell>
		    <cf_pdf_text>Date</cf_pdf_text>
		 </cf_pdf_cell>
         <cf_pdf_cell>
    		 <cf_pdf_text>#DateFormat(Batch.Created, CLIENT.DateFormatShow)#</cf_pdf_text>
		 </cf_pdf_cell>
		 
		 </cfoutput>
		
   		 </cf_pdf_table>
		 
		 <cf_pdf_text>.</cf_pdf_text>
		 
		<cf_pdf_font file="#SESSION.rootpath#\\tools\\fonts\\Tahoma.ttf" name="tahoma">
	    <cf_pdf_table numcols="6" align="Center" columnwidth="40,340,50,70,70,70" border="1" bordercolor = "F6F6F6">
		
		 <cf_pdf_cell>
		    <cf_pdf_text>Item</cf_pdf_text>
		 </cf_pdf_cell>
         <cf_pdf_cell>
    		 <cf_pdf_text>Description</cf_pdf_text>
		 </cf_pdf_cell>
         <cf_pdf_cell>
     		<cf_pdf_text>UoM</cf_pdf_text>
		 </cf_pdf_cell>
         <cf_pdf_cell align="right">
		    <cf_pdf_text>Reference</cf_pdf_text>
		 </cf_pdf_cell>
         <cf_pdf_cell align="right">
		    <cf_pdf_text>Quantity</cf_pdf_text>
		 </cf_pdf_cell>
         <cf_pdf_cell align="right">
		    <cf_pdf_text>Picked</cf_pdf_text>
		 </cf_pdf_cell> 
	
		<cfoutput query="SearchResult" group="Location">
				
		<cf_pdf_cell bgcolor="C0C0C0" height=10 colspan="6">
		    <cf_pdf_text font="tahoma" color="6688aa">#Location#</cf_pdf_text>
		</cf_pdf_cell>
	    		
		<cfoutput>
		
		 <cf_pdf_cell>
		    <cf_pdf_text>#ItemNo#</cf_pdf_text>
		 </cf_pdf_cell>
         <cf_pdf_cell>
    		 <cf_pdf_text>#ItemDescription#</cf_pdf_text>
		 </cf_pdf_cell>
         <cf_pdf_cell>
     		<cf_pdf_text>#TransactionUoM#</cf_pdf_text>
		 </cf_pdf_cell>
	    <cf_pdf_cell>
		    <cf_pdf_text>#Reference#</cf_pdf_text>
		 </cf_pdf_cell>
		 
         <cf_pdf_cell align="right">
		    <cf_pdf_text>#TransactionQuantity*-1#</cf_pdf_text>
		 </cf_pdf_cell>
       
         <cf_pdf_cell align="right">
		    <cf_pdf_text>________</cf_pdf_text>
		 </cf_pdf_cell>
		 
		 <!---
		<cf_pdf_cell bgcolor="gray" height=1 colspan="6">
		    <cf_pdf_text></cf_pdf_text>
 		</cf_pdf_cell> 
		--->
		 
		</cfoutput>
		
		</cfoutput> 
		    		
		</cf_pdf_table>
		
		 <cf_pdf_line x1="20" y1="20" x2="600" y2="20" width="1" color="808080" />
		
	</cf_pdf_page>
	
	--->

</cf_pdf>





