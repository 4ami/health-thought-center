import express from 'express';
import errorHandler from '../middleware/error.js';
import AuthController from '../controller/auth/auth-controller.js';
const router = express.Router();

router.post('/sign-up', AuthController.register);
router.post('/sign-in', AuthController.login);
router.post('/token', AuthController.refreshToken)


router.use(errorHandler)
export default router;