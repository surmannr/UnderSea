﻿using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnderSea.Bll.Paging
{
    public static class PagingExtension
    {
        public static async Task<PagedResult<T>> ToPagedList<T>(this IQueryable<T> list, int pagesize, int pagenumber)
        {
            PagedResult<T> result = new PagedResult<T>() { 
                AllResultsCount = await list.CountAsync(),
                PageNumber = pagenumber,
                PageSize = pagesize,
                Results = await list.Skip(pagesize * (pagenumber - 1)).Take(pagesize).ToListAsync()
            };
            return result;
        }
    }
}
