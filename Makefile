# bump GH_TAGNAME and PORTVERSION to update the port
PORTNAME=	MeshCentral
PORTVERSION=	1.0.46
CATEGORIES=	net
MASTER_SITES=	http://mikael.urankar.free.fr/MeshCentral/:npm_cache
DISTFILES=	meshcentral-${DISTVERSION}-npm-cache${EXTRACT_SUFX}:npm_cache

MAINTAINER=	mikael@FreeBSD.org
COMMENT=	Full computer management web site

LICENSE=	APACHE20
LICENSE_FILE=	${WRKSRC}/LICENSE

BUILD_DEPENDS=	npm:www/npm-node16
RUN_DEPENDS=	node:www/node16

USE_GITHUB=	yes
GH_ACCOUNT=	Ylianst
GH_TAGNAME=	07aa35898ad3e53efeca385fae26567a97593fcc

#USERS=		meshcentral
#GROUPS=		meshcentral
USE_RC_SUBR=	meshcentral

# meshcentral node_modules directory:
MC=	${WRKDIR}/mc

# Helper targets for port maintainers
# See doc.txt for instructions
make-npm-cache:
	cd ${WRKDIR}/.npm && \
		${RM} -r _locks anonymous-cli-metrics.json
	cd ${WRKDIR} && \
		${TAR} -czf meshcentral-${DISTVERSION}-npm-cache${EXTRACT_SUFX} .npm

do-configure:
	${MKDIR} ${MC}
	${CP} ${FILESDIR}/packagejsons/package*.json ${MC}

do-build:
	cd ${MC} && ${SETENV} ${MAKE_ENV} \
		npm install --offline --ignore-script

#	cd ${MC} && ${SETENV} ${MAKE_ENV} \
#		npm install

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
