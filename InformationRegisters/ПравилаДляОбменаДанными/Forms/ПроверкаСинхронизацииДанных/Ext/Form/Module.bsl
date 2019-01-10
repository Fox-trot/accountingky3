﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКСписку(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПланыОбменаСПравиламиИзФайла", Истина);
	
	ОткрытьФорму("РегистрСведений.ПравилаДляОбменаДанными.Форма.ФормаСписка", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Проверено(Команда)
	ОтметитьВыполнениеДела();
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтметитьВыполнениеДела()
	
	ВерсияМассив  = СтрРазделить(Метаданные.Версия, ".");
	ТекущаяВерсия = ВерсияМассив[0] + ВерсияМассив[1] + ВерсияМассив[2];
	ХранилищеОбщихНастроек.Сохранить("ТекущиеДела", "ПланыОбмена", ТекущаяВерсия);
	
КонецПроцедуры

#КонецОбласти