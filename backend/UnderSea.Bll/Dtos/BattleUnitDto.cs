﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnderSea.Bll.Dtos
{
    public class BattleUnitDto
    {
        [Required(ErrorMessage = "Az egység azonosítójának megadása kötelező!")]
        public int Id { get; set; }
        [Required(ErrorMessage = "Az egység nevének megadása kötelező!")]
        public string Name { get; set; }
        [Required(ErrorMessage = "Az egység darabszámának megadása kötelező!")]
        public int Count { get; set; }
    }
}