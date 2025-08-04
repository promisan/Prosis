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

<cftry>
<cfdirectory action="CREATE" directory="#SESSION.rootPath#\cfrstage\mergepdf">
<cfcatch></cfcatch>
</cftry>

<cfparam name="format" default="PDF">

    <!--- ------------ --->
	<!--- general info --->
	<!--- ------------ --->
	  
		<cfdocument name="info"          
          format="PDF"
          pagetype="letter"
          orientation="portrait"
          unit="in"
          encryption="none"
          fontembed="Yes"
          scale="100"
          overwrite="Yes"
          backgroundvisible="Yes"
          bookmark="True"
          localurl="No">
		  
		  <cfdocumentsection name="Case Info">	 
		  
		  <cfoutput>
		  	<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 
		  </cfoutput>
	
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">

			<tr><td><cfinclude template="../../Claim/ControlOrganization/ClaimDetail.cfm"></td></tr>
			
			<tr><td><table width="100%" cellspacing="0" cellpadding="0" align="left" class="formpadding">
			
			<cfoutput>
			<cfif details.claimMemo neq "">
						
			<tr>
			<td colspan="2">
							
					<table width="100%" bordercolor="silver" border="0" cellspacing="0" cellpadding="0" class="formpadding">
					<tr><td>#Details.ClaimMemo#</td></tr>
					</table>
			</td>
			</tr>	
				
			</cfif>	
			</cfoutput>
			
			</table></td></tr>
						
		</cfdocumentsection>
		
	  </cfdocument>			  

	<!--- ------------------ --->	  
    <!--- documents attached --->
	<!--- ------------------ --->	  
	
	<cfquery name="Object" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    OrganizationObject
				WHERE   ObjectKeyValue4 = '#URL.claimid#' 
				AND     Operational = 1 
			</cfquery>
	  
	  <cfquery name="External" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT   R.*			
		    FROM     Ref_EntityDocument R
		    WHERE    R.DocumentType  = 'Attach'
			AND      R.Operational   = 1
			AND      R.DocumentId IN (SELECT DocumentId 
			                          FROM OrganizationObjectDocument
									  WHERE ObjectId = '#Object.Objectid#'
									  AND Operational = 1) 
			ORDER BY DocumentOrder 
			</cfquery>
			
			<cfpdf action="MERGE"
          name="att"
          overwrite="Yes"
          keepbookmark="True">	
				
			<cfoutput query="External">	
														
				<cfdocument name="att#currentrow#"
		             format="PDF"
		             pagetype="letter"
		             orientation="portrait"
		             unit="in"
		             encryption="none"
		             fontembed="Yes"
		             scale="100"            
		             backgroundvisible="Yes"
		             bookmark="True">
				 		  
				    <cfdocumentsection name="#DocumentDescription#">	  
			
						<table width="100%" height="90%" align="center" border="0" cellspacing="0" cellpadding="0">
						<td colspan="2">
										
								<table width="100%" bordercolor="silver" border="0" cellspacing="0" cellpadding="0" class="formpadding">
								<tr><td align="center"><font size="5"><b><u>#DocumentDescription#</b></font></td></tr>
								</table>
						</td>
						</tr>	
						</table>								
								
					</cfdocumentsection>
				
				</cfdocument>			
					  
				<cfset vname="att#currentrow#">
					  
				<cfpdfparam source="att#currentrow#">	
				
				<cfset go = 0>		 
				
					<cfdirectory action="LIST"
	             directory="#SESSION.rootDocumentPath#\#EntityCode#\#Object.ObjectId#"
	             name="Attachment"
	             filter="#documentcode#*.*"
	             sort="DateLastModified DESC"
	             type="all"
	             listinfo="name">	
							 
					<cfloop query="Attachment">
					 <cfif UCase(Right(name,4)) eq ".PDF" or
								 UCase(Right(name,4)) eq ".GIF" or 
							     UCase(Right(name,4)) eq ".JPG" or 
								 UCase(Right(name,4)) eq ".PNG">
					     <cfset go = 1>
					 </cfif>
					</cfloop>		 
							 
					<cfif go eq "1">		 
				  							 		
						<cfloop query="Attachment">
						    
							<cfif UCase(Right(name,4)) eq ".PDF">
							
							  	<cfpdfparam source="#SESSION.rootDocumentPath#\#External.EntityCode#\#Object.ObjectId#\#Name#">			
							
							<cfelseif UCase(Right(name,4)) eq ".GIF" or 
							     UCase(Right(name,4)) eq ".JPG" or 
								 UCase(Right(name,4)) eq ".PNG">
										
								<cfdocument name="doc#currentrow#"
							          format="PDF"
							          pagetype="letter"
							          margintop="0.0"
							          marginbottom="0.5"
							          marginright="0.1"
							          marginleft="0.1"
							          orientation="landscape"
							          unit="in"
							          encryption="none"
							          fontembed="Yes"
							          backgroundvisible="No"
							          bookmark="True">
							  
							  	  <cfdocumentsection name="Image:#Name#">
									 
									 <table width="100%" height="100%" cellspacing="0" cellpadding="0">
									 <tr><td height="15" align="left">#Name#</td></tr>
									 <tr><td height="1" bgcolor="silver"></td></tr>
									 <tr><td valign="top">
									 
									  <cfimage 
										  action="READ" 
										  source="#SESSION.rootDocumentPath#\#External.EntityCode#\#Object.ObjectId#\#Name#" 
										  name="showimage">
										  
										  <cfimage 
										  action="WRITETOBROWSER" source="#showimage#">
									 
																		 
									 </td></tr>
									 </table>							
								   
								 </cfdocumentsection>  
							  
								</cfdocument>
								
								<cfpdfparam source="doc#currentrow#">	
								
														
							</cfif>	
						</cfloop>			
					
					</cfif>		
							
															
		  </cfoutput>	  
		  
		  </cfpdf>
		  
<!--- -------------------- --->
<!---  status of actions   --->
<!--- -------------------- --->		


<!--- disabled   

	<cfdocument name="status"
            format="PDF"
            pagetype="letter"
            orientation="portrait"
            unit="in"
            encryption="none"
            fontembed="Yes"
            scale="100"            
            backgroundvisible="Yes"
            bookmark="True">
				 		  
	    <cfdocumentsection name="Claim Status Report">	  
			
			<cfoutput>
		  	<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 		   
			
			<table width="100%" height="90%" align="center" border="0" cellspacing="0" cellpadding="0">
			<td colspan="2">
							
					<table width="100%" bordercolor="silver" border="0" cellspacing="0" cellpadding="0">
					<tr><td align="center"><font size="5"><b><u>Claim Status Report</b></font></td></tr>
					</table>
			</td>
			</tr>	
			</table>	
						
			<cfdocumentitem type="pagebreak"></cfdocumentitem> 		
			
			<cfset url.objectid = object.objectid>
					
			<cfinclude template="ClaimDetailActivity.cfm">	
			
			 </cfoutput>	
						
		</cfdocumentsection>
				
	</cfdocument>	
	
--->					  
		  
<!--- -------------------- --->
<!---  status of expenses  --->
<!--- -------------------- --->		  

	<cfdocument name="expense"
            format="PDF"
            pagetype="letter"
            orientation="portrait"
            unit="in"
            encryption="none"
            fontembed="Yes"
            scale="100"            
            backgroundvisible="Yes"
            bookmark="True">
				 		  
	    <cfdocumentsection name="Expense Sheet">	  
			
			<cfoutput>
			
			<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 
			
			<table width="100%" height="90%" align="center" border="0" cellspacing="0" cellpadding="0">
			<td colspan="2">
							
					<table width="100%" bordercolor="silver" border="0" cellspacing="0" cellpadding="0" class="formpadding">
					<tr><td align="center"><font size="5"><b><u><cf_tl id="Expense sheet"></b></font></td></tr>
					</table>
			</td>
			</tr>	
			</table>		
			
			<cfdocumentitem type="pagebreak"></cfdocumentitem> 		
			
			<cfset url.objectid = object.objectid>
					
			<cfinclude template="ClaimDetailExpense.cfm">							
			
			</cfoutput>
								
		</cfdocumentsection>
				
	</cfdocument>			
	  
	  
	 
 <!--- ------------------- --->
 <!--- generated documents --->
 <!--- ------------------- --->
 
 	   <cfquery name="Embedded" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				   SELECT    * 
			       FROM      OrganizationObjectActionReport P INNER JOIN
			                 Ref_EntityDocument R ON P.DocumentId = R.DocumentId
			       WHERE     P.ActionId IN
			                       (SELECT     ActionId
			                        FROM          OrganizationObjectAction
							    	WHERE  ObjectId = '#Object.ObjectId#')
									
				   ORDER BY DocumentOrder					
      </cfquery>
	  
	  <cfif embedded.recordcount gte "1">
	  
	  	  <cfloop query="Embedded">
				
			  <cfdocument name="doc#currentrow#"
		          format="PDF"
		          pagetype="letter"
		          orientation="portrait"
		          unit="in"
		          encryption="none"
		          fontembed="Yes"
		          scale="80"
				 margintop    = "#documentmargintop#"
			      marginbottom = "#documentmarginbottom#"
			      marginright="0.4"
			      marginleft="0.4"
		          overwrite="Yes"
		          backgroundvisible="Yes"
		          bookmark="True"
		          localurl="No">				
															
					<cfset doc = DocumentDescription>
								
									
					<cfdocumentitem type="header">
					<table width="95%" cellspacing="0" cellpadding="0">
					<tr><td><cfoutput>#doc#</cfoutput></td></tr>
					</table>					
					</cfdocumentitem> 
					
					<cfdocumentitem type="footer">
					<table width="95%" align="center" cellspacing="0" cellpadding="0">
					<tr><td><cfoutput>6 Lloyds Avenue, London EC3 N3ES<br>
							Company Registration ## 5930147</cfoutput></td>
					</tr>
					</table>					
					</cfdocumentitem> 
				
					<cfdocumentsection name="#DocumentDescription#">	
					
					<cfoutput>
					#DocumentContent#
					</cfoutput>
					 
					</cfdocumentsection>	
					
					<link rel="stylesheet" type="text/css" href="cfdocs.css">	
					<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 
					
					<cfdocumentitem type="pagebreak"></cfdocumentitem> 							
						  
				</cfdocument>
				
			</cfloop>		
		
	</cfif>	
		
		
<!--- final merge --->

<cfpdf action="MERGE"
          destination="#SESSION.rootPath#\cfrstage\mergepdf\#Object.ObjectId#.pdf"
          overwrite="Yes"
          keepbookmark="Yes">
		  
	<cfpdfparam source="info">
	
	<cfpdfparam source="att">
	
	<!---
	<cfpdfparam source="status">
	--->
	
	<cfpdfparam source="expense">
	
	<cfloop query="embedded">
	   <cfpdfparam source="doc#currentrow#">
	</cfloop>
				
</cfpdf>		

<!--- attributes --->

<cfset PDFinfo=StructNew()>
<cfset PDFinfo.Title    = "Case File">
<cfset PDFinfo.Author   = "Insight Loss Adjusters">
<cfset PDFinfo.Keywords = "Karin">
<cfset PDFinfo.Subject  = "Case File">

<cfpdf action="setInfo" 
   source="#SESSION.rootPath#\cfrstage\mergepdf\#Object.ObjectId#.pdf" 
   info="#PDFinfo#" 
   destination="#SESSION.rootPath#\cfrstage\mergepdf\#Object.ObjectId#.pdf" 
   overwrite="yes">

<cfoutput>
	<script>
		window.open("#SESSION.root#/cfrstage/mergepdf/#Object.ObjectId#.pdf","_blank")
	</script>
</cfoutput>	


