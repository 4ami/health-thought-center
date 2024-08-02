import express from 'express';
import CourseController from '../controller/course-controller.js';
const router = express.Router();

router.get('/courses', CourseController.getAll);
router.post('/enroll', CourseController.enroll);
router.get('/', CourseController.search)

export default router;