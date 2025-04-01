import request from '@/utils/request'

// 获取课程列表
export function getCourseList(params) {
  return request({
    url: '/vue-element-admin/course/list',
    method: 'get',
    params
  })
}

// 获取已选课程列表
export function getEnrollmentList(params) {
  return request({
    url: '/vue-element-admin/enrollment/list',
    method: 'get',
    params
  })
}

// 选课
export function selectCourse(data) {
  return request({
    url: '/vue-element-admin/enrollment/select',
    method: 'post',
    data
  })
}

// 退选
export function cancelCourse(data) {
  return request({
    url: '/vue-element-admin/enrollment/cancel',
    method: 'post',
    data
  })
}