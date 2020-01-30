<style>
div.x-panel-body
{
overflow: auto;
}
</style>

<cfquery name="SourceList" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_Source
		WHERE    AllowAssessment = 1		
    </cfquery>	
	
<cfloop query="SourceList">

 <cfquery name="Keywords" 
       datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
		SELECT   R1.Description AS CategoryDescription, 
		         R.SkillCode, 
				 R.SkillDescription, 
				 A.*
		FROM     Ref_AssessmentCategory R1 INNER JOIN
                 Ref_Assessment R ON R1.Code = R.AssessmentCategory INNER JOIN
                 RosterSearchLine A ON R.SkillCode = A.SelectId
		WHERE    A.SearchId = '#URL.ID#' 
		AND      A.SearchClass = 'Assessed#source#'
		ORDER BY R.AssessmentCategory, R.ListingOrder			
    </cfquery>	
	
	<cfset source = sourcelist.source>

 <table width="96%" align="center">
   
   <td colspan="4" height="20"> 
   <table width="100%"  cellspacing="0" cellpadding="0">
   <tr>
      <td valign="top" width="15%" class="labelit">
	
	 <table><tr><td width="20" style="padding-top:2px">
	 <cfoutput>
	 
	 <cf_img icon="open" onClick="skill()">
	 
	 <!---
  	 <button type="button" class="button3" onClick="skill()">
			   <img src="#SESSION.root#/Images/select4.gif" 
			    onMouseOver="document.img6.src='#SESSION.root#/Images/button.jpg'"
	 			onMouseOut="document.img6.src='#SESSION.root#/Images/select4.gif'"
				id="img6"
				name="img6"
			    alt="Select Assessement keywords" 
			    border="0" 
			    height="13"
			    width="13"
			    align="absmiddle" 
			    style="cursor: pointer;">
	 </button>
	 --->
	 
	 </td>
	 <td class="labelmedium" style="padding-left:1px">
     <a title="Select Assessement keywords" href="javascript:skill('#source#')"><font color="0080C0">#Description# (#Source#)</a>
	 </td>
	 
	 </cfoutput>
	 
	 </td></tr></table>
	 </td>
	 
	 
	 <cfif keywords.recordcount gte "2">
	
	 <td width="10"></td>	
	 
	 <td width="40" valign="top" class="labelit" style="padding-top:5px">
	 
		 <cfquery name="Operator" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT *
			FROM   RosterSearchLine
			WHERE SearchClass = 'Assessed#source#Operator'
			AND   SearchId = '#URL.ID#'				  
		</cfquery>	
		
		<table><tr><td>
		<cfoutput>
		 
			 <input type="radio"
	       name="Assessed#Source#Operator" <cfif Operator.recordcount eq "1">checked</cfif> value="ANY"></td><td style="padding-left:4px" class="labelit">ANY</td>
		  </tr>
		  <tr><td> 
		 	  <input type="radio"
	       name="Assessed#Source#Operator" <cfif Operator.recordcount neq "1">checked</cfif> value="ALL"></td><td style="padding-left:4px" class="labelit">ALL</td>
		</cfoutput>  
		</td>
		</tr>
		
		</table>  
	 	   
	 </td>	
	 
	</cfif>	  
	 
	<td height="1" style="padding-top:5px">				
						
	<table width="97%" align="right">
	
	<cfoutput query="Keywords" group="CategoryDescription">
	
	<cfquery name="Operator" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE SearchClass = 'Assessed#source#Operator'
		AND   SearchId = '#URL.ID#'				  
	</cfquery>		
	
	<tr>
	   	<td width="100%" align="left" class="labelit" colspan="3"><font color="808080">#CategoryDescription#</td>		
	</tr>
	
		<cfoutput>
					
			<tr>
			     <td width="80%" class="labelit">&nbsp;&nbsp;- #SkillDescription#</td>
				 <td align="right"></td>				 
				 <td width="2%" align="right" style="padding-right:4px">
				   <cf_img icon="delete" onClick="skilldel('Assessed#source#','#SelectId#')">				   
				 </td>
			</tr>
			
			
		</cfoutput>
			
	</cfoutput>
			
	</table>

	</td>
	 	 
	</tr>
    	
	<tr><td class="padding-top:4px"></td></tr>
	
	</table> 
   </td>  
   	
				
</table>

</cfloop>
