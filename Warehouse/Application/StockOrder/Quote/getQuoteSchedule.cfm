
<cfquery name="getHeader" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT   TOP 1 *,   (SELECT TOP 1 PriceSchedule 
				  FROM   CustomerRequestLine 
				  WHERE  RequestNo = P.RequestNo) as PriceSchedule
	FROM     CustomerRequest P
	WHERE    RequestNo = '#url.requestNo#'				
</cfquery>

<cfquery name="mySchedule" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT    *
	   FROM      Ref_PriceSchedule
	   WHERE     Operational = 1  	
	   ORDER BY  ListingOrder   
</cfquery>
 		
<cfoutput>

<select name="priceschedulequote" class="regularxxl" style="background-color:f1f1f1;border-bottom:0px" onchange="setpriceschedule(this.value,'#url.requestno#')">

	<cfloop query = "myschedule">	
  		<option value="#Code#" <cfif getHeader.priceschedule eq Code>selected</cfif>>#Description#</option>				
	</cfloop>
	
</select>
</cfoutput>
	
