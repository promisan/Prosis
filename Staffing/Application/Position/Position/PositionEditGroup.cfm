
<cfparam name="AccessPosition" default="none">

<cfparam name="URL.ID2" default="0">



<script>

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight4";
	 }else{		
     itm.className = "regular";		
	 }
  }

</script>

<cfparam name="URL.Domain" default="Position">

<cfquery name="Position" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  *
	FROM    Position
	WHERE   PositionNo = '#url.id2#'			 
</cfquery>

<cfquery name="GroupAll" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   F.*, S.PositionNo, S.Status AS Status
	FROM     PositionGroup S RIGHT OUTER JOIN
             Ref_Group F ON S.PositionGroup = F.GroupCode AND S.Status <> '9' AND S.PositionNo = '#URL.ID2#'
	WHERE    F.GroupCode IN
                    (SELECT   GroupCode
                     FROM     Ref_Group
                     WHERE    GroupDomain = '#URL.Domain#'
					 AND      GroupCode IN (SELECT GroupCode 
					                        FROM   Ref_GroupMission 
											WHERE  Mission = '#url.id#')
					)					 
</cfquery>

<!---

<cfif groupAll.recordcount eq "0">	
	
	<cfquery name="GroupAll" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT   F.*, S.PositionNo, S.Status AS Status
		FROM     PositionGroup S RIGHT OUTER JOIN
	             Ref_Group F ON S.PositionGroup = F.GroupCode AND S.Status <> '9' AND S.PositionNo = '#URL.ID2#'
		WHERE    F.GroupCode IN
	                    (SELECT   GroupCode
	                     FROM     Ref_Group
	                     WHERE    GroupDomain = '#URL.Domain#'
						 AND      Operational = 1					
						)					 
	</cfquery>

</cfif>

--->

<cfif GroupAll.recordcount eq "0">
<font style="color:gray">No position categorizations  enabled for entity</font>
</cfif>
  
<table width="100%">

<tr>			
    
		<td style="padding-left:0px">		
		<cfset row = 0>		
		<table>
			
			<cfoutput query="GroupAll">		
					
			<cfif row eq "0"><tr></cfif>
			
			<cfset row = row+1>
			
			<td>
			
				<table bgcolor="white">
						
				      <TR bgcolor="white">					
					
						<CFIF AccessPosition eq "EDIT" OR AccessPosition eq "ALL">
						
							<TD style="height:14px;padding-right:4px">
						
							<cfif PositionNo eq "">
							<input type="checkbox" class="radiol" name="positiongroup" value="#GroupCode#" onClick="hl(this,this.checked)">
							<cfelse>
							<input type="checkbox" class="radiol" name="positiongroup" value="#GroupCode#" checked onClick="hl(this,this.checked)">
						    </cfif>
							
							</td>
							
							
						<cfelse>						
						
							<cfif PositionNo neq "">
							<TD style="height:14px;padding-right:4px">
							  <img src="#SESSION.root#/Images/check_mark.gif" align="absmiddle" alt="" border="0">						
							 </td> 
							</cfif>							
					   
						</CFIF>
														
						<TD class="labelit" style="height:14px;padding-right:10px"><cfif PositionNo neq ""><cfelse><font color="808080"></cfif>#Description#&nbsp;&nbsp;|</TD>			
		
					</tr>
					
				</table>
			</td>
			
			<cfif row eq "3">
			 <cfset row = 0>
			    </tr>
			</cfif>	
					
			</CFOUTPUT>
		
		</table>		
		</td>	
</tr>

</table>
  
