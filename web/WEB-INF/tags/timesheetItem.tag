<%@ include file="../jsp/inc/_taglibs.jsp" %>
<%@ tag description = 
		"This tag generates the display data for timesheet querys" %>

<!-- The name of the attribute containing the collection of backlogTimeSheetNodes -->
<%@ attribute type="java.util.Collection" name="nodes" %>

<c:forEach items="${nodes}" var="node">
	<c:set var="divId" value="${divId + 1}" scope="request" />
	<c:set var="blueLeft" value="leftborder"/>
	<c:if test="${aef:isProduct(node.backlog)}">
		<c:set var="type" value="product"/>
		<c:set var="rowsymbols" value=""/>
	</c:if>
	<c:if test="${aef:isProject(node.backlog)}">
		<c:set var="type" value="project"/>
		<c:set var="rowsymbols" value="&raquo; "/>
	</c:if>
	<c:if test="${aef:isIteration(node.backlog)}">
		<c:set var="type" value="iteration"/>
		<c:set var="rowsymbols" value="&nbsp;&nbsp;&raquo; "/>
		<c:set var="blueLeft" value=""/>
	</c:if>
	<tr>
		<c:if test="${!(empty node.hourEntries && empty node.childStorys)}">
			<th class="${type} first" colspan="3">${rowsymbols}<a onclick="javascript:if($('.story.node${divId}').is(':visible')) { $('.node${divId}').hide(); } else { $('.story.node${divId}').show(); }"><c:out value="${node.backlog.name}"/></a></th>
		</c:if>
		<c:if test="${empty node.hourEntries && empty node.childStorys}">
			<th class="${type} first" colspan="3">${rowsymbols}<c:out value="${node.backlog.name}"/></th>
		</c:if>
		<th class="${type}"><c:out value="${node.hourTotal}"/></th> 
	</tr>
	<c:if test="${!empty node.hourEntries}">
		<c:set var="heDivId" value="${heDivId + 1}" scope="request" />
		<tr class="story node${divId} special hourentryhead ${blueLeft} toggleall">
			<th class="story first" colspan="3"><a onclick="javascript:$('.hour${heDivId}').toggle();">Logged effort</a></th>
			<th class="story fourth"><c:out value="${node.spentHours}"/></th>
		</tr>
		<c:forEach items="${node.hourEntries}" var="he">
			<tr class="hourentries hour${heDivId} node${divId} ${blueLeft} toggleall">
				<td class="hourentry first"><c:out value="${he.description}"/></td>
				<td class="hourentry second"><ww:date name="#attr.he.date" format="dd.MM.yyyy HH:mm" /></td>
				<td class="hourentry third">${aef:html(he.user.fullName)}</td>
				<td class="hourentry fourth">${aef:html(he.timeSpent)}</td>
			</tr>
		</c:forEach>
	</c:if>
	<c:if test="${!empty node.childStorys}">
		<c:if test="${!aef:isIteration(node.backlog)}">
			<tr class="story node${divId} special storyshead ${blueLeft} toggleall">
				<th class="story first" colspan="3">Stories</th>
				<th class="story fourth">${aef:html(node.hoursForChildStorys)}</th>
			</tr>
		</c:if>
		<c:forEach items="${node.childStorys}" var="story">
			<c:set var="heDivId" value="${heDivId + 1}" scope="request" />
			<tr class="story node${divId} ${blueLeft} toggleall">
				<c:if test="${!empty story.hourEntries}">
					<th class="story first" colspan="3">&nbsp; &nbsp; &raquo; <a onclick="javascript:$('.hour${heDivId}').toggle();"><c:out value="${story.story.name}"/></a></th>
				</c:if>
				<c:if test="${empty story.hourEntries}">
					<th class="story first" colspan="3">&nbsp; &nbsp; &raquo; <c:out value="${story.story.name}"/></th>
				</c:if>
				<th class="story"><c:out value="${story.hourTotal}"/></th>
			</tr>
			<c:forEach items="${story.hourEntries}" var="he">
				<tr class="hourentries hour${heDivId} node${divId} ${blueLeft} toggleall">
					<td class="hourentry first"><c:out value="${he.description}"/></td>
					<td class="hourentry second"><ww:date name="#attr.he.date" format="dd.MM.yyyy HH:mm" /></td>
					<td class="hourentry third">${aef:html(he.user.fullName)}</td>
					<td class="hourentry fourth">${aef:html(he.timeSpent)}</td>
				</tr>
			</c:forEach>
		</c:forEach>										
	</c:if>
	<c:if test="${!empty node.childBacklogs}">
		<aef:timesheetItem nodes="${node.childBacklogs}" />
	</c:if>
</c:forEach>
