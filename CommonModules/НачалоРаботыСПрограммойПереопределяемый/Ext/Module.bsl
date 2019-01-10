﻿
Процедура ОбработкаЗакрытияФормыНачалаРаботы(ЗначенияРеквизитов, ПараметрыНачалаРаботы, ОбработкаЗавершена) Экспорт
	
	ПараметрыРаботыКлиента = ПараметрыНачалаРаботы.ПараметрыРаботыКлиента;
	
	ОбновитьПользователя(ЗначенияРеквизитов, ПараметрыРаботыКлиента);
	
	ЗафиксироватьОкончаниеПервогоВходаВПрограмму();
	
	ОбработкаЗавершена = Истина;
	
КонецПроцедуры

#Область БП

Процедура ОбновитьПользователя(ЗначенияРеквизитов, ПараметрыРаботыКлиента)
	Перем ПользовательСсылка;
	
	Если НЕ ЗначенияРеквизитов.Свойство("Пользователь", ПользовательСсылка)
		ИЛИ НЕ ЗначениеЗаполнено(ПользовательСсылка) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Если ПараметрыРаботыКлиента.РазделениеВключено Тогда
		
		ПользовательОбъект = ПользовательСсылка.ПолучитьОбъект();
		
	Иначе
		ПользовательСсылка = Справочники.Пользователи.ПолучитьСсылку(Новый УникальныйИдентификатор);
		ПользовательОбъект = Справочники.Пользователи.СоздатьЭлемент();
		ПользовательОбъект.УстановитьСсылкуНового(ПользовательСсылка);
		
		// Доступно только в локальном режиме
		ПользовательОбъект.Наименование = ЗначенияРеквизитов.ПользовательИмя;
		
		ОписаниеПользователяИБ = Новый Структура;
		ОписаниеПользователяИБ.Вставить("Действие",					"Записать");
		ОписаниеПользователяИБ.Вставить("Имя",						ЗначенияРеквизитов.ПользовательИмя);
		ОписаниеПользователяИБ.Вставить("ПолноеИмя",				ЗначенияРеквизитов.ПользовательИмя);
		ОписаниеПользователяИБ.Вставить("Пароль", 					ЗначенияРеквизитов.ПользовательПароль);
		ОписаниеПользователяИБ.Вставить("АутентификацияСтандартная",Истина);
		ОписаниеПользователяИБ.Вставить("ПарольУстановлен", 		Истина);
		ОписаниеПользователяИБ.Вставить("ПоказыватьВСпискеВыбора",	Истина);
		
		ДоступныеРоли = Новый Массив;
		ДоступныеРоли.Добавить(Метаданные.Роли.АдминистраторСистемы.Имя);
		ДоступныеРоли.Добавить(Метаданные.Роли.ПолныеПрава.Имя);
		ОписаниеПользователяИБ.Вставить("Роли", ДоступныеРоли);
		
		ПользовательОбъект.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
		ПользовательОбъект.ДополнительныеСвойства.Вставить("СозданиеАдминистратора", НСтр("ru = 'Создание первого администратора.'"));
		
		ПользовательОбъект.Служебный = Ложь;
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ПользовательОбъект, Ложь, Истина);
	
	// Скрывает предупреждения безопасности, всплывающие при первом открытии сеанса администратора.
	Пользователи.УстановитьПравоОткрытияВнешнихОтчетовИОбработок(Истина);
	
	// Заполнение настроек по умолчанию.
	ОсновнаяОрганизация = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(ПользовательСсылка, "ОсновнаяОрганизация");
	БухгалтерскийУчетСервер.УстановитьНастройкуПользователя(ОсновнаяОрганизация, "ОсновнаяОрганизация", ПользовательСсылка);
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура ЗафиксироватьОкончаниеПервогоВходаВПрограмму()
	
	Константы.ДатаПервогоВходаВСистему.Установить(ТекущаяДата());
	
КонецПроцедуры

#КонецОбласти