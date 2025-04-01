const Mock = require('mockjs')

// 生成课程数据
const courses = []
for (let i = 1; i <= 10; i++) {
  courses.push({
    course_id: 100000 + i,
    course_name: `课程${i}`,
    credit: Mock.Random.integer(1, 5),
    teacher_id: 200000 + Mock.Random.integer(1, 5),
    teacher_name: `教师${Mock.Random.integer(1, 5)}`,
    max_seats: 100,
    current_seats: Mock.Random.integer(0, 80),
    exam_type: Mock.Random.pick(['闭卷', '开卷', '论文', '大作业'])
  })
}

// 生成已选课程数据
const enrollments = []
const studentId = 111 // 默认学生ID

// 为默认学生生成2-3门已选课程
const selectedCourseCount = Mock.Random.integer(2, 3)
for (let i = 0; i < selectedCourseCount; i++) {
  const courseIndex = Mock.Random.integer(0, courses.length - 1)
  enrollments.push({
    enroll_id: 10000 + i,
    student_id: studentId,
    course_id: courses[courseIndex].course_id,
    course_name: courses[courseIndex].course_name,
    credit: courses[courseIndex].credit,
    teacher_name: courses[courseIndex].teacher_name,
    exam_type: courses[courseIndex].exam_type,
    status: 1,
    enroll_time: Mock.Random.datetime('yyyy-MM-dd HH:mm:ss')
  })
}

module.exports = [
  // 获取课程列表
  {
    url: '/vue-element-admin/course/list',
    type: 'get',
    response: config => {
      return {
        code: 20000,
        data: {
          total: courses.length,
          items: courses
        }
      }
    }
  },

  // 获取已选课程列表
  {
    url: '/vue-element-admin/enrollment/list',
    type: 'get',
    response: config => {
      const { studentId = 111 } = config.query
      const data = enrollments.filter(item => item.student_id === parseInt(studentId) && item.status === 1)
      
      return {
        code: 20000,
        data: {
          total: data.length,
          items: data
        }
      }
    }
  },

  // 选课
  {
    url: '/vue-element-admin/enrollment/select',
    type: 'post',
    response: config => {
      const { studentId, courseId } = config.body
      
      // 检查是否已经选过该课程
      const existEnrollment = enrollments.find(item => 
        item.student_id === parseInt(studentId) && 
        item.course_id === parseInt(courseId) &&
        item.status === 1
      )
      
      if (existEnrollment) {
        return {
          code: 50000,
          message: '已经选过该课程'
        }
      }
      
      // 检查课程是否存在
      const course = courses.find(item => item.course_id === parseInt(courseId))
      if (!course) {
        return {
          code: 50000,
          message: '课程不存在'
        }
      }
      
      // 检查课程是否已满
      if (course.current_seats >= course.max_seats) {
        return {
          code: 50000,
          message: '课程已满'
        }
      }
      
      // 创建选课记录
      const newEnrollment = {
        enroll_id: 10000 + enrollments.length,
        student_id: parseInt(studentId),
        course_id: parseInt(courseId),
        course_name: course.course_name,
        credit: course.credit,
        teacher_name: course.teacher_name,
        exam_type: course.exam_type,
        status: 1,
        enroll_time: Mock.Random.datetime('yyyy-MM-dd HH:mm:ss')
      }
      
      enrollments.push(newEnrollment)
      
      // 更新课程已选人数
      course.current_seats += 1
      
      return {
        code: 20000,
        data: 'success'
      }
    }
  },

  // 退选
  {
    url: '/vue-element-admin/enrollment/cancel',
    type: 'post',
    response: config => {
      const { studentId, courseId } = config.body
      
      // 查找选课记录
      const enrollmentIndex = enrollments.findIndex(item => 
        item.student_id === parseInt(studentId) && 
        item.course_id === parseInt(courseId) &&
        item.status === 1
      )
      
      if (enrollmentIndex === -1) {
        return {
          code: 50000,
          message: '未选择该课程'
        }
      }
      
      // 更新选课状态为退选
      enrollments[enrollmentIndex].status = 0
      
      // 更新课程已选人数
      const course = courses.find(item => item.course_id === parseInt(courseId))
      if (course) {
        course.current_seats -= 1
      }
      
      return {
        code: 20000,
        data: 'success'
      }
    }
  }
]