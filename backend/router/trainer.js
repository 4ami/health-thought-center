import express from 'express';
import auhenticateAPIKEY from '../middleware/varify-key.js';
import TrainerController from '../controller/trainer/trainer-controller.js';

const router = express.Router();

router.get('/my-courses/:id', auhenticateAPIKEY, TrainerController.getMyCourses)
router.post('/create/:id', auhenticateAPIKEY, TrainerController.newCourse)

export default router;