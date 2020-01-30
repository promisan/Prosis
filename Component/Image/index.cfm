<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>ColdFusion Image Effects by Foundeo</title>
		<style type="text/css">
			body { font-family: verdana,arial; margin:10px;background: white url('Images/header_bk.gif') repeat-x;}
			code { font-weight: bold; }
			pre { background-color: #f1f1f1; padding: 8px; width:800px; }
			h2 { border-bottom: 1px solid #f1f1f1; margin-top: 15px; }
			th { text-align:left; border-bottom: 1px solid silver; }
			
		</style>
	</head>
	<body>
		<a href="http://foundeo.com/"><img src="Images/foundeo.png" border="0" alt="foundeo" align="right" /></a>
		<br />
		<h1>ColdFusion Image Effects for CFImage by Foundeo</h1>
	
		<p>The <a href="http://foundeo.com/image-effects/">ColdFusion Image Effects for CFImage</a> comprises of a CFC called <code>CFImageEffects</code> with the following functions. </p>
	
		<h2>CFImageEffects component quick reference</h2>
		<table border="0" cellpadding="0" cellspacing="0" class="quickref formpadding">
			<tr>
				<th>Function Name</th>
				<th>Arguments</th>
			</tr>
			<tr>
				<td><code>drawGradientFilledRect</code></td>
				<td valign="top"><code>(imageObj, x, y, width, height, startColor, endColor, gradientDirection)</code></td>
			</tr>
			<tr>
				<td><code>applyReflectionEffect</code></td>
				<td><code>(imageObj <em>[, backgroundColor, mirrorHeight, startOpacity]</em>)</code></td>
			</tr>
			<tr>
				<td><code>applyPlasticEffect</code></td>
				<td><code>(imageObj <em>[, backgroundColor, startOpacity, endOpacity]</em>)</code></td>
			</tr>
			<tr>
				<td><code>applyRoundedCornersEffect</code></td>
				<td><code>(imageObj <em>[, backgroundColor, cornerSize]</em>)</code></td>
			</tr>
			<tr>
				<td><code>applyDropShadowEffect</code></td>
				<td><code>(imageObj <em>[, backgroundColor, shadowColor, shadowWidth, shadowDistance]</em>)</code></td>
			</tr>
		</table>
		<p><a href="docs.html">View CFImageEffects Component Documentation</a></p>
	
		<br />
		<br />
		
		<h2>Reflection Effect Example</h2>
		<p>The reflection effect has been made popular by Apple in programs such as iTunes, the iPhone, and more. It makes the image appear to be on a shiny, glossy glass surface.</p>
		<h3>Source Code For Reflection Effect Example</h3>
		<cffile action="read" file="#ExpandPath("reflection-example.cfm")#" variable="source">
		<pre><cfoutput>#XmlFormat(source)#</cfoutput></pre>
		<table border="0" width="400" cellspacing="0" cellpadding="0" class="formpadding">
			<tr>
				<td><h3>Source Image</h3></td>
				<td><h3>Reflection on White</h3></td>
				<td><h3>Reflection on Black</h3></td>
			</tr>
			<tr>
				<td valign="top"><img src="Images/spendfish.png" border="0" alt="spendfish" /></td>
				<td valign="top"><img src="reflection-example.cfm" alt="reflection" border="0" /></td>
				<td valign="top" bgcolor="black" style="padding:20px 50px;"><img src="reflection-example.cfm?backgroundColor=black" alt="reflection" border="0" /></td>
			</tr>
		</table>
		
		<h2>Rounded Corners Example</h2>
		<p>This example uses the <code>RoundedCornersEffect</code> to add rounded corners to an image.</p>
		<h3>Source Code for Rounded Corners Example</h3>
		<cffile action="read" file="#ExpandPath("rounded-corners-example.cfm")#" variable="source">
		<pre><cfoutput>#XmlFormat(source)#</cfoutput></pre>
		<h3>Generated Image</h3>
		<p>
			<img src="rounded-corners-example.cfm" alt="cf-logo-example" border="0" />
		</p>
		
		<h2>ColdFusion Logo Example</h2>
		<p>This example uses the <code>DrawGradientFilledRect</code> and the <code>ApplyDropShadowEffect</code> methods along with ColdFusion's Builtin <code>ImageDrawText</code> function to create the ColdFusion 8 Logo.</p>
		<h3>Source Code for ColdFusion Logo Example</h3>
		<cffile action="read" file="#ExpandPath("cf-logo-example.cfm")#" variable="source">
		<pre><cfoutput>#XmlFormat(source)#</cfoutput></pre>
		<h3>Generated Image</h3>
		<p>
			<img src="cf-logo-example.cfm" alt="cf-logo-example" border="0" />
		</p>
		
		<h2>Plastic Button Example</h2>
		<p>This example uses the <code>DrawGradientFilledRect</code>, <code>ApplyPlasticEffect</code>, <code>ApplyRoundedCornersEffect</code>, and the <code>ApplyReflectionEffect</code> methods to create a plastic looking button.</p>
		<h3>Source Code for Plastic Button Example</h3>
		<cffile action="read" file="#ExpandPath("plastic-button-example.cfm")#" variable="source">
		<pre><cfoutput>#XmlFormat(source)#</cfoutput></pre>
		<h3>Generated Image</h3>
		<p>
			<img src="plastic-button-example.cfm" alt="cf-logo-example" border="0" />
		</p>
		
		<h3>Gradient Filled Rectangle Example</h3>
		<p><a href="gradient-example.cfm">Click Here</a> for this example.</p>
		
	</body>
</html>