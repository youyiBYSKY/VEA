<template>
  <div class="app-container">
    <div class="filter-container">
      <el-button v-waves class="filter-item" type="primary" icon="el-icon-refresh" @click="getList">
        刷新
      </el-button>
    </div>

    <el-table
      v-loading="listLoading"
      :data="list"
      element-loading-text="加载中"
      border
      fit
      highlight-current-row
      style="width: 100%"
    >
      <el-table-column label="课程编号" align="center" width="120">
        <template slot-scope="{row}">
          <span>{{ row.course_id }}</span>
        </template>
      </el-table-column>
      <el-table-column label="课程名称" min-width="150px">
        <template slot-scope="{row}">
          <span>{{ row.course_name }}</span>
        </template>
      </el-table-column>
      <el-table-column label="学分" width="80" align="center">
        <template slot-scope="{row}">
          <span>{{ row.credit }}</span>
        </template>
      </el-table-column>
      <el-table-column label="授课教师" width="120" align="center">
        <template slot-scope="{row}">
          <span>{{ row.teacher_name }}</span>
        </template>
      </el-table-column>
      <el-table-column label="考试方式" width="100" align="center">
        <template slot-scope="{row}">
          <span>{{ row.exam_type }}</span>
        </template>
      </el-table-column>
      <el-table-column label="选课时间" width="160" align="center">
        <template slot-scope="{row}">
          <span>{{ row.enroll_time }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="120" class-name="small-padding fixed-width">
        <template slot-scope="{row}">
          <el-button type="danger" size="mini" @click="handleCancel(row)">
            退选
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="listQuery.page"
      :limit.sync="listQuery.limit"
      @pagination="getList"
    />
  </div>
</template>

<script>
import { getEnrollmentList, cancelCourse } from '@/api/course'
import waves from '@/directive/waves' // waves directive
import Pagination from '@/components/Pagination' // secondary package based on el-pagination

export default {
  name: 'SelectedCourse',
  components: { Pagination },
  directives: { waves },
  data() {
    return {
      list: null,
      total: 0,
      listLoading: true,
      listQuery: {
        page: 1,
        limit: 10
      },
      studentId: 111 // 默认学生ID，实际应用中应从用户信息中获取
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.listLoading = true
      getEnrollmentList({ ...this.listQuery, studentId: this.studentId }).then(response => {
        this.list = response.data.items
        this.total = response.data.total
        this.listLoading = false
      })
    },
    handleCancel(row) {
      this.$confirm('确认退选该课程?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        cancelCourse({
          studentId: this.studentId,
          courseId: row.course_id
        }).then(response => {
          this.$message({
            type: 'success',
            message: '退选成功!'
          })
          this.getList()
        }).catch(error => {
          this.$message({
            type: 'error',
            message: error.message || '退选失败'
          })
        })
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消操作'
        })
      })
    }
  }
}
</script>