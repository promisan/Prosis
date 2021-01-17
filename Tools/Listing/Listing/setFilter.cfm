
<!--- set filter --->

<cfparam name="url.box"        default=""> 

<cfparam name="session.listingdata['#url.box#']['explore']" default="0">

<cfset explore    = session.listingdata[url.box]['explore']>
<cfset sorting    = session.listingdata[url.box]['sqlsorting']>
<cfset listlay    = session.listingdata[url.box]['listlayout']>

<cfoutput>

<!--- 0. explore enabled / disabled --->

<cfif explore eq "1">

	<script>			
	    $('###box#_column1').addClass('regular').removeClass('hide')	
		$('###box#_groupcell1').addClass('hide').removeClass('regular')		
		$('###box#_groupcell1formula').addClass('hide').removeClass('regular')		
	</script>	
	
	<!--- 1. control the visibility of the check box to sort the grouping or not --->
	
	<cfset sortgroup = "1">
	
	<cfloop array="#listlay#" index="current">
	
	       <cfparam name="current.aggregate" default="">
		<cfif current.aggregate eq "sum">	
		
			<cfif findNoCase(current.field,sorting)>
			 	<cfset sortgroup = "0">																					
			</cfif>
		
		</cfif>
									
	</cfloop>
		
	<cfif sortgroup eq "0">
		<script>
			$('###box#_groupsort').addClass('hide').removeClass('regular')		
		</script>
	<cfelse>
	    <script>
			$('###box#_groupsort').addClass('regular').removeClass('hide')		
		</script>
	</cfif>
	
	<!--- 2. control the visibility of the summary cell which is not relevant --->
	
	<cfparam name="session.listingdata[url.box]['colnfield']" default="">
	
	<cfset cell1 = session.listingdata[url.box]['colnfield']>
	
	<cfif cell1 eq "">
	
		<script>	   
			$('###box#_groupcell1').addClass('hide').removeClass('regular')		
			$('###box#_groupcell1formula').addClass('hide').removeClass('regular')		
		</script>
	
	<cfelse>
	
	    <script>
			$('###box#_groupcell1').addClass('regular').removeClass('hide')		
			$('###box#_groupcell1formula').addClass('regular').removeClass('hide')
		</script>
	
	</cfif>
	
	
	<!--- 3. control the visibility of the summary cell which is not relevant --->
	
	<cfparam name="session.listingdata[url.box]['datacell1']" default="">
	
	<cfset formula1 = session.listingdata[url.box]['datacell1']>
	
	<cfif formula1 eq "Total">
	
		<script>			
			$('###box#_groupcell1formula').addClass('hide').removeClass('regular')		
		</script>
	
	<cfelse>
	
	    <script>		
			$('###box#_groupcell1formula').addClass('regular').removeClass('hide')
		</script>
	
	</cfif>
	
<cfelse>

    <script>		
	    $('###box#_column1').addClass('hide').removeClass('regular')		 
		$('###box#_groupcell1').addClass('hide').removeClass('regular')		
		$('###box#_groupcell1formula').addClass('hide').removeClass('regular')
	</script>

</cfif>	

</cfoutput>









