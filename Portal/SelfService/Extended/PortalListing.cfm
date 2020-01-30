
<!--- HTML5 --->
<!DOCTYPE html>

<html>

	<head>
		<style>
			html, body {
				height:100%;
				width:100%;
				margin:0px;
			}
		</style>
	</head>
	
<body>

<cfoutput>
	<cfif url.idMenu eq "">
		
		<br>
		<br>
		<div align="center">
			<span style="color:red;"><h2><cf_tl id="Undefined listing id"></h2></span>
		</div>
	
	<cfelse>
		<div class="waitListing">
			<div><img src="#session.root#/images/busy10.gif"></div>
			<div style="padding-top:5px;"><table><tr><td class="labelit"><cf_tl id="Loading">...</td></tr></table></div>
		</div>
		<iframe 
			id="iframeListing"
			frameborder="0"
			style="display:none; height:99.9%; width:100%;"
			onload="$('.waitListing').css('display','none'); $(this).fadeIn(350);" 
			src="#session.root#/Tools/Listing/Listing/Inquiry.cfm?webapp=Portal&idMenu=#url.idMenu#&height=800">
		</iframe>
	</cfif>
</cfoutput>

</body>

</html>
