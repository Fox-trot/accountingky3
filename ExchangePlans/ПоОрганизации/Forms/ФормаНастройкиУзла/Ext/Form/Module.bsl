﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбменДаннымиСервер.ФормаНастройкиУзлаПриСозданииНаСервере(ЭтаФорма, "ПоОрганизации");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

&НаСервере
Функция ПустаяСсылкаНаВСправочникеОрганизации()
	
	Возврат Справочники.Организации.ПустаяСсылка();
	
КонецФункции

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПустаяСсылка = ПустаяСсылкаНаВСправочникеОрганизации();
	КоличествоСтрок = Организации.Количество();
	КоллекцияЗначений = Новый Массив;
	ИндексДляВставления = 0;
	
	Пока КоличествоСтрок > 0 Цикл
		НужнаяСтрока  = Организации[КоличествоСтрок-1];
		Если НужнаяСтрока.Организация = ПустаяСсылка Тогда 
			Организации.Удалить(НужнаяСтрока);
		Иначе
			Если КоллекцияЗначений.Найти(НужнаяСтрока.Организация) <> Неопределено Тогда
				Организации.Удалить(НужнаяСтрока);
			Иначе
				КоллекцияЗначений.Вставить(ИндексДляВставления,НужнаяСтрока.Организация);
				ИндексДляВставления = ИндексДляВставления + 1;
			КонецЕсли;
		КонецЕсли;
		КоличествоСтрок = КоличествоСтрок - 1;
	КонецЦикла;
	
	Если Организации.Количество() = 0 Тогда 
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не выбрана ни одна организация!'");
		Сообщение.Сообщить();
	Иначе 
		ОбменДаннымиКлиент.ФормаНастройкиУзлаКомандаЗакрытьФорму(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры
