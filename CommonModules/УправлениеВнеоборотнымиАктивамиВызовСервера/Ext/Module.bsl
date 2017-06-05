﻿
// Функция - Получить параметры учета ОС
//
// Параметры:
//  Период			 - Дата	 								- дата, на которую нужно получить сведения
//  Организация		 - СправочникСсылка.Организации	 		- организация для отбора
//  ОсновноеСредство - СправочникСсылка.ОсновноеСредство	- основное средство для отбора
// 
// Возвращаемое значение:
//  ПараметрыУчетаОС - Структура с параметрами 
//
Функция ПолучитьПараметрыУчетаОС(Период, Организация, ОсновноеСредство) Экспорт
	Возврат УправлениеВнеоборотнымиАктивамиСервер.ПолучитьПараметрыУчетаОС(Период, Организация, ОсновноеСредство); 
КонецФункции // ОпределитьСтоимостьПоСпискуОС()

// Функция - Рссчитывает амортизацию ОС и возвращает сумму
//
// Параметры:
//  Период			 - Дата	 								- дата, на которую нужно получить сведения
//  Организация		 - СправочникСсылка.Организации	 		- организация для отбора
//  ОсновноеСредство - СправочникСсылка.ОсновноеСредство	- основное средство для отбора
// 
// Возвращаемое значение:
//  СуммаАмортизации - Число
//
Функция РасчетАмортизацииОсновногоСредства(Период, Организация, ОсновноеСредство) Экспорт
	Возврат УправлениеВнеоборотнымиАктивамиСервер.РасчетАмортизации(Период, Организация, ОсновноеСредство); 
КонецФункции // РасчетАмортизацииОсновногоСредства()

