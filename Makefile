PORTNAME=	MeshCentral
PORTVERSION=	0.8.26
CATEGORIES=	security
MASTER_SITES=	http://mikael.urankar.free.fr/MeshCentral/:npm_cache
DISTFILES=	meshcentral-npm-cache-${DISTVERSION}${EXTRACT_SUFX}:npm_cache

MAINTAINER=	mikael@FreeBSD.org
COMMENT=	full computer management web site

LICENSE=	APACHE20
LICENSE_FILE=	${WRKSRC}/LICENSE

BUILD_DEPENDS=	npm>0:www/npm
RUN_DEPENDS=	node>0:www/node

USE_GITHUB=	yes
GH_ACCOUNT=	Ylianst
GH_TAGNAME=	ed6dcb96dbc79b6ac06e4a250c2680690cf52ff1

USE_RC_SUBR=	meshcentral

# meshcentral node_modules directory:
MC=	${WRKDIR}/mc

# Helper targets for port maintainers
# Make sure the package*json are up to date
# Don't forget to add the missing modules, grep modules.push meshcentral.js
# Don't forget to copy package.json and package-lock.json in ${FILESDIR}/packagejsons
# do "make configure" before executing this target
make-npm-cache:
	${CP} ${FILESDIR}/packagejsons/package*.json ${WRKSRC}
	cd ${WRKDIR} && ${RM} -r .npm
	cd ${WRKSRC} && \
		${SETENV} HOME=${WRKDIR} npm install --ignore-scripts
	cd ${WRKDIR}/.npm && \
		${RM} -r _locks anonymous-cli-metrics.json
	cd ${WRKDIR} && \
		${TAR} -czf meshcentral-npm-cache-${DISTVERSION}${EXTRACT_SUFX} .npm

do-configure:
	${MKDIR} ${MC}
	${CP} ${FILESDIR}/packagejsons/package*.json ${MC}

do-build:
	cd ${MC} && ${SETENV} ${MAKE_ENV} \
		npm install --offline --ignore-script

do-install:
	${RM} ${MC}/package*.json

	${MKDIR} ${STAGEDIR}${PREFIX}/meshcentral
	(cd ${MC} && ${COPYTREE_SHARE} . ${STAGEDIR}${PREFIX}/meshcentral)

	${MKDIR} ${STAGEDIR}${PREFIX}/meshcentral/node_modules/meshcentral
	(cd ${WRKSRC} && ${COPYTREE_SHARE} . ${STAGEDIR}${PREFIX}/meshcentral/node_modules/meshcentral)

.include <bsd.port.mk>
