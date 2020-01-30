<cfparam name="URL.ID" default="">

<cfquery name="List" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ClassElement
	WHERE ElementClass = 'UseCase'
	ORDER By ListingOrder
</cfquery>


<cfquery name="ctype" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT ClassFunctionType
    FROM ClassFunction
	WHERE ClassFunctionId='#url.id#'
</cfquery>

<cfoutput>

<cfset attrib = {type="Tab",name="ClassInfo",tabheight="#client.height-260#",height="#client.height-225#",width="#client.width-106#"}>

<cflayout attributeCollection="#attrib#">
				
		<cfloop query="list">		
				
			 <cflayoutarea 
	          name="n#elementCode#"
			  source="UseCaseTextArea.cfm?id=#url.Id#&elementCode=#elementcode#"
	          title="#ElementDescription#"
	          overflow="auto"/>	
			
		</cfloop>				

		<cfif ctype.ClassFunctionType eq "AService">
		
			 <cflayoutarea 
	          name="Attributes" style="border-color:ffffff;width:100%"
    	      title="Attributes"
	          overflow="auto">		
				  <table cellspacing="0" width="100%"
			      cellpadding="0">
				  <tr>
  				  <td width="2%"></td>
				  <td valign="top">			  
				  <cfdiv id="bAttributes" bind ="url:UseCaseSelectAttr.cfm?id=#url.Id#"/>
	 		  	  </td>
				  <td width="2%"></td>
				  </tr></table>	  
			</cflayoutarea>	
		
		</cfif>
	
	</cflayout>	
		
</cfoutput>	