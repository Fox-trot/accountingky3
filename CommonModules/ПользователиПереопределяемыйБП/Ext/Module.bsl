﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// См. ПользователиПереопределяемый.ПриУстановкеНачальныхНастроек.
Процедура ПриУстановкеНачальныхНастроек(НачальныеНастройки) Экспорт
	
	// БПКР
	НачальныеНастройки.НастройкиИнтерфейса.ОтображениеПанелиРазделов = ОтображениеПанелиРазделов.КартинкаИТекст;
	//НачальныеНастройки.НастройкиКлиента.ВариантИнтерфейсаКлиентскогоПриложения = ВариантИнтерфейсаКлиентскогоПриложения.Такси;
	//НачальныеНастройки.НастройкиКлиента.ВариантМасштабаФормКлиентскогоПриложения = ВариантМасштабаФормКлиентскогоПриложения.Компактный;
	
	Если Константы.ИнтерфейсВерсии82.Получить() Тогда
		НачальныеНастройки.НастройкиКлиента.ВариантИнтерфейсаКлиентскогоПриложения = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2;
	Иначе
		НачальныеНастройки.НастройкиКлиента.ВариантИнтерфейсаКлиентскогоПриложения = ВариантИнтерфейсаКлиентскогоПриложения.Такси;
	КонецЕсли;
	
	Если НачальныеНастройки.НастройкиТакси <> Неопределено Тогда
		НастройкиСостава = Новый НастройкиСоставаИнтерфейсаКлиентскогоПриложения;
		ГруппаЛево = Новый ГруппаНастройкиСоставаИнтерфейсаКлиентскогоПриложения;
		ГруппаЛево.Добавить(Новый ЭлементНастройкиСоставаИнтерфейсаКлиентскогоПриложения("ПанельИнструментов"));
		ГруппаЛево.Добавить(Новый ЭлементНастройкиСоставаИнтерфейсаКлиентскогоПриложения("ПанельРазделов"));
		НастройкиСостава.Верх.Добавить(Новый ЭлементНастройкиСоставаИнтерфейсаКлиентскогоПриложения("ПанельОткрытых"));
		НастройкиСостава.Лево.Добавить(ГруппаЛево);
		НачальныеНастройки.НастройкиТакси.УстановитьСостав(НастройкиСостава);
	КонецЕсли;
	// Конец БПКР
	
КонецПроцедуры

// См. ПользователиПереопределяемый.ПриПолученииПрочихНастроек.
Процедура ПриПолученииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	// БПКР
	// Получение значения настройки ЗапрашиватьПодтверждениеПриЗавершенииПрограммы.
	ЗначениеНастройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ОбщиеНастройкиПользователя", 
		"ЗапрашиватьПодтверждениеПриЗавершенииПрограммы",,, СведенияОПользователе.ИмяПользователяИнформационнойБазы);
	Если ЗначениеНастройки <> Неопределено Тогда
		
		СписокЗначенийНастройки = Новый СписокЗначений;
		СписокЗначенийНастройки.Добавить(ЗначениеНастройки);
		
		ИнформацияОНастройке    = Новый Структура;
		ИнформацияОНастройке.Вставить("НазваниеНастройки", НСтр("ru = 'Подтверждение при закрытии программы'"));
		ИнформацияОНастройке.Вставить("КартинкаНастройки", "");
		ИнформацияОНастройке.Вставить("СписокНастроек", СписокЗначенийНастройки);
		
		Настройки.Вставить("ЗапрашиватьПодтверждениеОЗакрытии", ИнформацияОНастройке);
	КонецЕсли;
	// Конец БПКР
	
КонецПроцедуры

// См. ПользователиПереопределяемый.ПриСохраненииПрочихНастроек.
Процедура ПриСохраненииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	// БПКР
	Если Настройки.ИдентификаторНастройки = "ЗапрашиватьПодтверждениеОЗакрытии" Тогда
		ЗначениеНастройки = Настройки.ЗначениеНастройки[0];
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"ОбщиеНастройкиПользователя", "ЗапрашиватьПодтверждениеПриЗавершенииПрограммы",
			ЗначениеНастройки.Значение,, СведенияОПользователе.ИмяПользователяИнформационнойБазы);
	КонецЕсли;
	// Конец БПКР
	
КонецПроцедуры

// См. ПользователиПереопределяемый.ПриУдаленииПрочихНастроек.
Процедура ПриУдаленииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	// БПКР
	Если Настройки.ИдентификаторНастройки = "ЗапрашиватьПодтверждениеОЗакрытии" Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекУдалить(
			"ОбщиеНастройкиПользователя", "ЗапрашиватьПодтверждениеПриЗавершенииПрограммы",
			СведенияОПользователе.ИмяПользователяИнформационнойБазы);
	КонецЕсли;
	// Конец БПКР
	
КонецПроцедуры

#КонецОбласти
