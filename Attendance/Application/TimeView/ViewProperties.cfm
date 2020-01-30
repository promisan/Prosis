
<cfquery name="class" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_TimeClass
	WHERE    ShowInAttendance = 1
	ORDER BY ListingOrder
</cfquery>		

<table width="100%" border="0" align="center">
<tr><td style="padding:10px">	
									
	<table width="100%" border="0" align="center">
	
	<tr class="line"><td><cf_tl id="Legend"></td></tr>
		
		<cfoutput query="class">
		<tr class="labelit" style="height:25px">
		   <td align="center" style="width:80%" bgcolor="#viewcolor#">#DescriptionShort# [#left(Description,1)#]</td>
		</tr>   
		</cfoutput>		
		</tr>
	</table>

</td></tr>	
</table>
				
				