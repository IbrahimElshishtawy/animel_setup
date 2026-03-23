"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const mapController_1 = require("../controllers/user/mapController");
const router = (0, express_1.Router)();
router.get('/markers', mapController_1.getMapMarkers);
exports.default = router;
//# sourceMappingURL=mapRoutes.js.map