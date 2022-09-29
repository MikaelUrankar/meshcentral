# Ajout user meshcentral dans UIDs/GIDs
# meshcentral:*:1003:1003::0:0:meshcentral pseudo user:/nonexistent:/usr/sbin/nologin
# meshcentral:*:1002:

# See doc.txt for updating instructions

PORTNAME=	MeshCentral
PORTVERSION=	1.0.85
CATEGORIES=	net
MASTER_SITES=	http://mikael.urankar.free.fr/MeshCentral/:npm_cache
DISTFILES=	${PORTNAME}-${DISTVERSION}-npm-cache${EXTRACT_SUFX}:npm_cache

MAINTAINER=	mikael@FreeBSD.org
COMMENT=	Full computer management web site

LICENSE=	APACHE20
LICENSE_FILE=	${WRKSRC}/LICENSE

BUILD_DEPENDS=	npm:www/npm-node16
RUN_DEPENDS=	node:www/node16

USE_GITHUB=	yes
GH_ACCOUNT=	Ylianst
GH_TAGNAME=	c86466210b69c52dcb9fa0f4ac24323818a6ce4a

USERS=		meshcentral
GROUPS=		meshcentral
USE_RC_SUBR=	meshcentral

# meshcentral node_modules directory:
MC=	${WRKDIR}/mc

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

create-caches-tarball:
	# do some cleanup first
	${RM} -r  ${WRKDIR}/.npm/_logs ${WRKDIR}/.npm/_update-notifier-last-checked ${WRKDIR}/.cache/yarn/v6/.tmp

	cd ${WRKDIR} && \
		${TAR} czf ${PORTNAME}-${DISTVERSION}-npm-cache.tar.gz .npm

.include <bsd.port.mk>
