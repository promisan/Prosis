	
	<cfquery name="PositionParent" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT *
		 FROM  PositionParent		 
		 WHERE PositionParentId = '#URL.ID2#'	 
	</cfquery>
	
    <table cellspacing="0" width="97%">
	<tr><td height="3"></td></tr>
	
	<tr class="line"><td height="35" colspan="4" style="font-size:20px" class="labelmedium"><cf_tl id="Budget Position"></td></tr>  	
		
	 <cfoutput>      
	  
	   <tr class="labelmedium">
        <td height="15" style="width:200px;min-width:200px;max-width:200px;padding-left:6px"><cf_tl id="Title">:</td>
        <td colspan="1"><b>#PositionParent.FunctionDescription#</td>
		<td height="15"><cf_tl id="Reference2">:</td>
        <td colspan="1"><b>#PositionParent.ApprovalReference#</td>
      </tr>
	 	 	  
	  <tr class="labelmedium">
        <td height="15" style="padding-left:6px"><cf_tl id="Post type">:</td>
        <td colspan="1"><b>#PositionParent.PostType# (#PositionParent.Fund#)</td>
		<td height="15"><cf_tl id="Approval">:</td>
        <td width="100" colspan="1"><b>#dateformat(PositionParent.ApprovalDate,CLIENT.DateFormatShow)#</td>
		
      </tr>
	  
	   <tr class="labelmedium">
        <td height="15" style="padding-left:6px"><cf_tl id="Grade">:</td>
        <td colspan="1"><b>#PositionParent.PostGrade#</td>
		<td height="15"><cf_tl id="Grade approved">:</td>
        <td colspan="1"><b>#PositionParent.ApprovalPostGrade#</td>
		
      </tr>
	  
	  </cfoutput>
	  
	   <tr class="labelmedium">
        <td valign="top" style="PADDING-TOP:5PX;padding-left:6px"><cf_tl id="Operational Structure">:</td>
		
		<td colspan="4">
		
		<table width="98%">		
		
		<cfquery name="Level00" 
          datasource="AppsEmployee" 
          username="#SESSION.login#" 
          password="#SESSION.dbpw#">
          SELECT * 
          FROM   Organization.dbo.Organization
          WHERE  OrgUnit = '#PositionpARENT.OrgUnitOperational#'
	    </cfquery>					  
		
	    <cfset Mission   = Level00.Mission>
	    <cfset MandateNo = Level00.MandateNo>
		<cfset Parent    = Level00.ParentOrgUnit>
		
		<cfif Parent neq "">
		  <cfset List = "'#Level00.OrgUnitCode#','#parent#'">
		<cfelse>
		  <cfset List = "'#Level00.OrgUnitCode#'"> 
		</cfif>  
	      
	    <cfloop condition="Parent neq ''">
				
		    <cfquery name="LevelUp" 
	          datasource="AppsOrganization" 
	          username="#SESSION.login#" 
	          password="#SESSION.dbpw#">
	          SELECT * 
	          FROM   Organization
	          WHERE  OrgUnitCode = '#Parent#'
			    AND  Mission     = '#Mission#'
			    AND  MandateNo   = '#MandateNo#'
		   </cfquery>	    
		   
		   <cfif LevelUp.ParentOrgUnit neq "">
			   <cfset List = "#list#,'#LevelUp.ParentOrgUnit#'">			   
		   </cfif>		
		   
		   <cfset Parent = LevelUp.ParentOrgUnit>
		
		</cfloop>
				
		 <cfquery name="Org" 
          datasource="AppsEmployee" 
          username="#SESSION.login#" 
          password="#SESSION.dbpw#">
          SELECT   * 
          FROM     Organization.dbo.Organization
		  WHERE    Mission     = '#Mission#'
		  AND      MandateNo   = '#MandateNo#'
          AND      OrgUnitCode IN (#preservesinglequotes(List)#)
		  ORDER BY HierarchyCode
	   </cfquery>
	   
	   <cfset Indent = "0">
					
	   <cfoutput query="Org">
	   
	   	   <cfif currentrow eq recordcount>
		   	<cfset cl = "yellow">
		   <cfelse>
		   	<cfset cl = "ffffff">	
		   </cfif>	
	   	   
	       <TR class="labelmedium line" style="background-color:#cl#">		   		   	  
	          <td style="min-width:100px;padding-left:#indent#px">
			  <cfif currentrow eq recordcount>
			  <img src="#SESSION.root#/Images/bullet.gif" height="20"  border="0" align="absmiddle">	          
			  <cfelse>
			  <img src="#SESSION.root#/Images/bullet.gif" height="15"  border="0" align="absmiddle">		  
			  </cfif>
	       </td>
	       <td width="40%">#Mission# - #OrgUnitName#</td>
	       <TD width="10%">#OrgUnitCode#</TD>
	       <TD width="30%">#OrgUnitClass#</TD>
		   <TD width="10%">#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</TD>	 
	       </TR>
		   
		   <cfset Indent = indent+20>
	   
	   </cfoutput>  
  
	   </table>
	   
	   </td>
	   </tr>
	 		 
	  <cfoutput> 
	  	  	  	  
	  <tr class="labelmedium">
        <td height="20" style="padding-left:6px"><cf_tl id="Effective period">:</td>
        <td colspan="2" class="labelmedium"><b>#Dateformat(PositionParent.DateEffective, CLIENT.DateFormatShow)#
		- #Dateformat(PositionParent.DateExpiration, CLIENT.DateFormatShow)#
		</td>
      </tr>
	 	  
	  </cfoutput>
	  
	  <tr><td class="line" colspan="4" height="7"></td></tr>
	
	  
</table>	  