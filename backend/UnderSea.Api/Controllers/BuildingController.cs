﻿using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnderSea.Bll.Dtos;
using UnderSea.Bll.Services;
using UnderSea.Bll.Services.Interfaces;

namespace UnderSea.Api.Controllers
{
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    [Route("api/[controller]")]
    [ApiController]
    public class BuildingController : ControllerBase
    {
        private readonly IBuildingService service;

        public BuildingController(IBuildingService service)
        {
            this.service = service;
        }

        [HttpGet("user-buildings")]
        public async Task<ActionResult<IEnumerable<BuildingDetailsDto>>> GetUserBuildings()
        {
            var userbuildings = await service.GetUserBuildingAsync();
            return Ok(userbuildings);
        }

        [HttpPost("buy")]
        public async Task<ActionResult> BuyBuilding(BuyBuildingDto buildingDto)
        {
            await service.BuyBuildingAsync(buildingDto);
            return Ok();
        }
    }
}
