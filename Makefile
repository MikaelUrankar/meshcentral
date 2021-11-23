# bump GH_TAGNAME and PORTVERSION to update the port
PORTNAME=	MeshCentral
PORTVERSION=	0.9.33
CATEGORIES=	net
MASTER_SITES=	http://mikael.urankar.free.fr/MeshCentral/:npm_cache
DISTFILES=	meshcentral-npm-cache-${DISTVERSION}${EXTRACT_SUFX}:npm_cache

MAINTAINER=	mikael@FreeBSD.org
COMMENT=	Full computer management web site

LICENSE=	APACHE20
LICENSE_FILE=	${WRKSRC}/LICENSE

BUILD_DEPENDS=	npm>0:www/npm
RUN_DEPENDS=	node>0:www/node

USE_GITHUB=	yes
GH_ACCOUNT=	Ylianst
GH_TAGNAME=	555641b35ca86127032178385e79a21971b2c2f1

USERS=		meshcentral
GROUPS=		meshcentral
USE_RC_SUBR=	meshcentral

# meshcentral node_modules directory:
MC=	${WRKDIR}/mc

# Helper targets for port maintainers
# See doc.txt for instructions
make-npm-cache:
	${CP} ${FILESDIR}/packagejsons/package*.json ${WRKSRC}
	cd ${WRKDIR} && ${RM} -r .npm
	cd ${WRKSRC} && ${RM} -r node_modules
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

	${RM} \
		${STAGEDIR}${PREFIX}/meshcentral/node_modules/readdirp/node_modules/extglob/lib/.DS_Store \
		${STAGEDIR}${PREFIX}/meshcentral/node_modules/readdirp/node_modules/micromatch/lib/.DS_Store

.include <bsd.port.mk>
