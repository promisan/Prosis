
<script>

function reload() { 
   opener.location.reload();
   window.close();
}

function ShowPicture(itm) {
	ptoken.open("ItemPicture_FileForm.cfm?ID=" + itm, "PhotoWindow", "width=550, height=300, scrollbars=no, resizable=no");
}

</script>

<cf_dialogPosition>

<cfparam name="URL.Source" default="MANUAL">
<cfparam name="URL.Caller" default="">

<cfquery name="Position" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM Position
    WHERE PositionNo = '#URL.ID#'</cfquery>
	
<cfquery name="LastAssignment" 
datasource="AppsEmployee" 
maxrows=1 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM PersonAssignment
    WHERE PositionNo = '#URL.ID#'
	ORDER BY DateEffective DESC</cfquery>	

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr class="noprint">
  
    <cfoutput>
	
    <td height="26" width="70%" class="labelmedium2">			
		#Position.SourcePostNumber# #Position.FunctionDescription# #Position.PostGrade# (#Position.PositionNo#)			
    </td>
	
	<td align="right" style="padding-right:10px">
	
	<cfif url.Caller neq "PostDialog">
	
		<cf_tl id="Edit Position" var="vEditPosition">
		
		<input type="button" 
		       name="Edit" 
			   value="#vEditPosition#" 
			   style="width:120px;height:20px"
			   class="button10g" 
			   onClick="javascript:EditPosition('#Position.Mission#','#Position.MandateNo#','#Position.PositionNo#')">
	</cfif>
	
	</td>
	
	</cfoutput>
		
  </tr> 	
  
  <tr>
	<td height="22" colspan="2" align="left">
	
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding formspacing">
		<tr><td width="170"  class="labelmedium"><cf_tl id="Position Authorised for" class="message">:</td>
			<td class="labelmedium"><b>
			
			<cfquery name="Parent" 
		    datasource="AppsEmployee" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    SELECT FunctionDescription, Org.OrgUnitName, Org.Mission
			    FROM   PositionParent A, Organization.dbo.Organization Org
			    WHERE  A.PositionParentId = '#Position.PositionParentId#'
				AND    A.OrgUnitOperational = Org.OrgUnit 
		   </cfquery>	
		   	   
		     <cfoutput>
			   <a href="javascript:EditPosition('#Position.Mission#','#Position.MandateNo#','#Position.PositionNo#')">
			   #Parent.Mission# #Parent.OrgUnitName# &nbsp; - #Parent.FunctionDescription#
			   </a>
		     </cfoutput>   
		   
		   </td>
	   </tr>
	   </table>
	   
   </td>
	    
  </tr>  
  <tr>
    <td width="100%" colspan="2" bgcolor="ffffff" style="padding:5px;border-left:3px solid gray">
	
    <table border="0" align="center" width="98%">
				  
	  <tr>
        <td style="height:20px;padding-top:5px" valign="top" height="18" class="labelit"><cf_tl id="Organization">:</td>
		
		<td colspan="4">
		
		<table width="100%">		
		
		<cfquery name="Level00" 
          datasource="AppsEmployee" 
          username="#SESSION.login#" 
          password="#SESSION.dbpw#">
          SELECT * 
          FROM   Organization.dbo.Organization
          WHERE  OrgUnit = '#Position.OrgUnitOperational#'
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
		   	<cfset cl = "ffffaf">
		   <cfelse>
		   	<cfset cl = "ffffff">	
		   </cfif>	
	   	   
	       <TR class="labelmedium line" style="background-color:#cl#">		   		   	  
	          <td style="min-width:100px;padding-left:#indent#px">
			  <cfif currentrow eq recordcount>
			  <img src="#SESSION.root#/Images/bullet.gif" height="20"  border="0" align="absmiddle">	          
			  <cfelse>
			  <img src="#SESSION.root#/Images/bullet.gif" height="16"  border="0" align="absmiddle">		  
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
    
      <tr class="labelmedium2">
        <td width="17%"><cf_tl id="Function">:</td>
        <td colspan="3">
		
		    <table>
			<tr class="labelmedium2">			
			<td><a href="javascript:EditPosition('#Position.Mission#','#Position.MandateNo#','#Position.PositionNo#')">
			    #Position.PostGrade# #Position.FunctionDescription#</a>
			</td>			
			<td style="padding-left:10px;height:20px"><cf_tl id="Post type">:</td>			
	        <td style="padding-left:5px;height:20px" colspan="3">#Position.PostType#</td>
	
			<cfif Position.SourcePostNumber neq "">
			
				<td style="padding-left:10px" >
				
					<cf_tl id="External Postnumber">:
					
					</td>
					
					<td style="padding-left:10px" class="labelmedium">
				
					#Position.Source#&nbsp;
				
					<cf_customLink
					   FunctionClass = "Staffing"
					   FunctionName  = "stPosition"
					   Key="#Position.SourcePostNumber#"> 
				
					<input type="hidden" name="SourcePostNumber" value="#Position.SourcePostNumber#">
				
				</td>
			
			</cfif>						
			
			</tr>
			</table>
			
		</td>
		
      </tr>
	 	 	  
	  
	  </cfoutput>
	   
	  <cfoutput> 
	  
	  <tr class="labelmedium2">
	    <td><cf_tl id="Location">:</td>
        <td colspan="2" align="left">
		<cfif Position.LocationCode eq ""><cf_tl id="not defined"><cfelse>
		
			<cfquery name="Location" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
			    FROM   Location
		    	WHERE  LocationCode = '#Position.LocationCode#'
			</cfquery>	
					
		#Location.LocationName#</cfif>
	  </td>
	  </tr>
	   
	  <tr class="labelmedium2">
        <td><cf_tl id="Class">:</td>
        <td colspan="2">#Position.PostClass#</td>
	 </tr>
	 	 	  	  	  
	  <tr class="labelmedium2">
        <td><cf_tl id="Effective">:</td>
        <td colspan="2">#Dateformat(Position.DateEffective, CLIENT.DateFormatShow)#
		- #Dateformat(Position.DateExpiration, CLIENT.DateFormatShow)#
		</td>
      </tr>
	 	  
	  </cfoutput>
	   	   
    </table>
    </td>
  </tr>
  
</table>
