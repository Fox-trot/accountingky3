﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// См. УправлениеСвойствамиПереопределяемый.ПриПолученииПредопределенныхНаборовСвойств.
Процедура ПриПолученииПредопределенныхНаборовСвойств(Наборы) Экспорт
	
	// Наборы справочника Контрагенты.
	Набор = Наборы.Строки.Добавить();
	Набор.Имя = "Справочник_Контрагенты";
	Набор.ЭтоГруппа = Истина;
	Набор.Идентификатор = Новый УникальныйИдентификатор("3001280c-f6ec-4fa9-bc4a-5eee8f177b60");
	
	ДочернийНабор = Набор.Строки.Добавить();
	ДочернийНабор.Имя = "Справочник_Контрагенты_Основное";
	ДочернийНабор.Идентификатор = Новый УникальныйИдентификатор("766448ee-5143-4c28-820d-1d272302ab61");
	
	ДочернийНабор = Набор.Строки.Добавить();
	ДочернийНабор.Имя = "Справочник_Контрагенты_Прочее";
	ДочернийНабор.Идентификатор = Новый УникальныйИдентификатор("3b4e0dcd-b7a6-4257-bc69-5118e7fb47e0");
	
	// Наборы справочника Номенклатура.
	Набор = Наборы.Строки.Добавить();
	Набор.Имя = "Справочник_Номенклатура";
	Набор.Идентификатор = Новый УникальныйИдентификатор("9265848a-53cc-470a-8778-20995e98f1ae");

	// Наборы справочника Физические лица.
	Набор = Наборы.Строки.Добавить();
	Набор.Имя = "Справочник_ФизическиеЛица";
	Набор.Идентификатор = Новый УникальныйИдентификатор("460cc238-2aab-4786-ad8d-28be986785bb");
	
КонецПроцедуры

// См. УправлениеСвойствамиПереопределяемый.ПриПолученииНаименованийНаборовСвойств.
Процедура ПриПолученииНаименованийНаборовСвойств(Наименования, КодЯзыка) Экспорт
	
	Наименования["Справочник_Контрагенты_Основное"] = НСтр("ru='Основное'; en='Main';", КодЯзыка);
	Наименования["Справочник_Контрагенты_Прочее"]   = НСтр("ru='Прочее'; en='Other';", КодЯзыка);
	
КонецПроцедуры

#КонецОбласти

