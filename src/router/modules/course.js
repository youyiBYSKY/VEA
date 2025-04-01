import Layout from '@/layout'

const courseRouter = {
  path: '/course',
  component: Layout,
  redirect: '/course/list',
  name: 'Course',
  meta: {
    title: '选课系统',
    icon: 'education'
  },
  children: [
    {
      path: 'list',
      component: () => import('@/views/course/course-list'),
      name: 'CourseList',
      meta: { title: '选课' }
    },
    {
      path: 'selected',
      component: () => import('@/views/course/selected-course'),
      name: 'SelectedCourse',
      meta: { title: '已选课程' }
    }
  ]
}

export default courseRouter