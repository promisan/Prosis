	
	<cfquery name="PositionParent" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT *
		 FROM  PositionParent		 
		 WHERE PositionParentId = '#URL.ID2#'	 
	</cfquery>
	
    <table width="98%" align="center">
		
	<cfoutput>
	
	<tr class="line labelmedium fixlengthlist">
	  <td colspan="1" style="height:35px;font-size:20px"><cf_tl id="Budget Position"></td>
	
        <td><cf_tl id="Effective period">:</td>
        <td colspan="2"><b>#Dateformat(PositionParent.DateEffective, CLIENT.DateFormatShow)#
		- #Dateformat(PositionParent.DateExpiration, CLIENT.DateFormatShow)#
		</td>     	  
	  </tr>  	    
	  
	   <tr class="labelmedium2 fixlengthlist" style="height:20px;background-color:f4f4f4">
        <td style="padding-left:6px"><cf_tl id="Title">:</td>
        <td><b>#PositionParent.FunctionDescription#</td>
		<td><cf_tl id="Reference2">:</td>
        <td><b>#PositionParent.ApprovalReference#</td>
      </tr>
	 	 	  
	  <tr class="labelmedium2 fixlengthlist" style="height:20px;background-color:f4f4f4">
        <td style="padding-left:6px"><cf_tl id="Post type">:</td>
        <td><b>#PositionParent.PostType# (#PositionParent.Fund#)</td>
		<td><cf_tl id="Approval">:</td>
        <td><b>#dateformat(PositionParent.ApprovalDate,CLIENT.DateFormatShow)#</td>
		
      </tr>
	  
	   <tr class="labelmedium2 fixlengthlist" style="height:20px;background-color:f4f4f4">
        <td style="padding-left:6px"><cf_tl id="Grade">:</td>
        <td><b>#PositionParent.PostGrade#</td>
		<td><cf_tl id="Grade approved">:</td>
        <td><b>#PositionParent.ApprovalPostGrade#</td>
		
      </tr>
	  
	  </cfoutput>
	  
	   <tr class="labelmedium2" style="height:20px;background-color:f4f4f4">
        <td valign="top" style="PADDING-TOP:2PX;padding-left:6px"><cf_tl id="Operational Structure">:</td>
		
		<td colspan="3" style="border:1px solid silver">
		
		<table width="100%">		
		
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
		   	<cfset cl = "transparent">	
		   </cfif>	
	   	   	      
		   <cfif currentrow eq recordcount>
			  
			  <TR class="labelmedium fixlengthlist" style="background-color:#cl#">		   		   	  
	          <td style="padding-left:#indent#px">
			  <img src="#SESSION.root#/Images/bullet.gif" height="20"  border="0" align="absmiddle">	
			  </td>          
			  
		   <cfelse>
		   
			  <TR class="labelit line fixlengthlist" style="background-color:#cl#">		   		   	  
	          <td style="padding-left:#indent#px">
			  <img src="#SESSION.root#/Images/bullet.gif" height="13"  border="0" align="absmiddle">	
			  </td>	  
			  
		   </cfif>
	       
	       <td style="padding-left:7px">#Mission# - #OrgUnitName#</td>
	       <TD>#OrgUnitCode#</TD>
	       <TD>#OrgUnitClass#</TD>
		   <TD>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</TD>	 
	       </TR>
		   
		   <cfset Indent = indent+20>
	   
	   </cfoutput>  
  
	   </table>
	   
	   </td>
	   </tr>
	   
	   <tr><td height="5"></td></tr>	 	  
	  
</table>	  