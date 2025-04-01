<template>
  <div class="app-container">
    <div class="filter-container">
      <el-input
        v-model="listQuery.keyword"
        placeholder="课程名称"
        style="width: 200px;"
        class="filter-item"
        @keyup.enter.native="handleFilter"
      />
      <el-button v-waves class="filter-item" type="primary" icon="el-icon-search" @click="handleFilter">
        搜索
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
      <el-table-column label="已选/容量" width="100" align="center">
        <template slot-scope="{row}">
          <span>{{ row.current_seats }}/{{ row.max_seats }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="120" class-name="small-padding fixed-width">
        <template slot-scope="{row}">
          <el-button 
            type="primary" 
            size="mini" 
            :disabled="row.current_seats >= row.max_seats"
            @click="handleSelect(row)"
          >
            选课
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
import { getCourseList, selectCourse } from '@/api/course'
import waves from '@/directive/waves' // waves directive
import Pagination from '@/components/Pagination' // secondary package based on el-pagination

export default {
  name: 'CourseList',
  components: { Pagination },
  directives: { waves },
  data() {
    return {
      list: null,
      total: 0,
      listLoading: true,
      listQuery: {
        page: 1,
        limit: 10,
        keyword: undefined
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
      getCourseList(this.listQuery).then(response => {
        this.list = response.data.items
        this.total = response.data.total
        this.listLoading = false
      })
    },
    handleFilter() {
      this.listQuery.page = 1
      this.getList()
    },
    handleSelect(row) {
      this.$confirm('确认选择该课程?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        selectCourse({
          studentId: this.studentId,
          courseId: row.course_id
        }).then(response => {
          this.$message({
            type: 'success',
            message: '选课成功!'
          })
          this.getList()
        }).catch(error => {
          this.$message({
            type: 'error',
            message: error.message || '选课失败'
          })
        })
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消选课'
        })
      })
    }
  }
}
</script>