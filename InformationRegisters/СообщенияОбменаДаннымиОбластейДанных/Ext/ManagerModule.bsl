﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьЗапись(СтруктураЗаписи) Экспорт
	
	ОбменДаннымиСлужебный.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "СообщенияОбменаДаннымиОбластейДанных");
	
КонецПроцедуры

Процедура УдалитьЗапись(СтруктураЗаписи) Экспорт
	
	Запись = РегистрыСведений.СообщенияОбменаДаннымиОбластейДанных.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, СтруктураЗаписи);
	Запись.Удалить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли