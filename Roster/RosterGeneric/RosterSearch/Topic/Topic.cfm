
<cfquery name="Topics" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT   R.Topic, R.Description, A.SelectId, A.SelectParameter,R.ListingOrder
		FROM     Ref_Topic R INNER JOIN
                 RosterSearchLine A ON R.Topic = A.SelectId
		WHERE    A.SearchId    = '#URL.ID#' 
		AND      A.SearchClass = 'SelfAssessment'		
		AND      R.ValueClass  = 'List'
		AND      R.Topic IN (SELECT Topic FROM Ref_TopicOwner WHERE Owner = '#url.owner#')
		ORDER BY R.ListingOrder		
		
</cfquery>	

 <table width="96%" align="center">
   
   <td colspan="4" height="20"> 
   <table width="100%"  cellspacing="0" cellpadding="0">
   <tr>
      <td valign="top" width="15%" class="labelmedium">
	
	 <table><tr><td width="20">
	 <cfoutput>
	 
  	 <button class="button3" type="button"
		   onClick="topic()">
		   <img src="#SESSION.root#/Images/select4.gif" 
			    onMouseOver="document.img6.src='#SESSION.root#/Images/button.jpg'" 
				onMouseOut="document.img6.src='#SESSION.root#/Images/select4.gif'"
				id="img99"
				name="img99"		    
			    border="0" 
			    height="13"
		    	width="13"
			    align="absmiddle" 
			    style="cursor: pointer;">
	 </button>
	 </td>
	 <td style="padding-left:4px" class="labelmedium">
          <a title="Select Topics" href="javascript:topic()"><font color="0080FF"><cf_tl id="Add selection"></a>
	 </td>
	 
	 </cfoutput>
	 
	 </td></tr></table>
	 </td>
	 
	 <cfif Topics.recordcount gte "2">
	
	 <td width="10"></td>	
	 
	 <td width="40" valign="top" class="labelit" style="padding-top:5px">
	 
		 <cfquery name="Operator" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT *
			FROM   RosterSearchLine
			WHERE  SearchClass = 'SelfAssessmentOperator'
			AND    SearchId = '#URL.ID#'				  
		</cfquery>	
		
		<table><tr><td>
		<cfoutput>
		 
		 <input type="radio"
	       name="SelfAssessmentOperator" <cfif Operator.recordcount eq "1">checked</cfif> value="ANY"></td><td style="padding-left:4px" class="labelit">ANY</td>
		  </tr>
		  <tr><td> 
		  <input type="radio"
	       name="SelfAssessmentOperator" <cfif Operator.recordcount neq "1">checked</cfif> value="ALL"></td><td style="padding-left:4px" class="labelit">ALL</td>
		</cfoutput>  
		</td>
		</tr>
		
		</table>  
	 	   
	 </td>	
	 
	</cfif>	  
	 
	<td height="1" style="padding-top:5px">				
						
	<table width="97%" align="right">
	
	<cfoutput query="Topics">
							
			<tr>
			     <td width="80%" class="labelit">&nbsp;&nbsp;- #Description# #SelectParameter#</td>
				 <td align="right"></td>				 
				 <td width="5%" align="right" style="padding-right:4px">
				   <cf_img icon="delete" onClick="topicdel('Assessment','#SelectId#')">				   
				 </td>
			</tr>			
			
	</cfoutput>
			
	</table>

	</td>
	 	 
	</tr>
    	
	<tr><td class="padding-top:4px"></td></tr>
	
	</table> 
   </td>  
   	
				
</table>

